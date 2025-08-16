import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  static final Map<String, List<Map<String, dynamic>>> _localMessages = {};
  static final Map<String, Map<String, dynamic>> _localChatRooms = {};
  static final StreamController<String> _messageController =
      StreamController<String>.broadcast();
  static bool _isInitialized = false;
  static Timer? _periodicTimer;

  // 데이터 초기화
  static Future<void> _initialize() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();

    // 저장된 메시지 로드
    final messagesJson = prefs.getString('chat_messages');
    if (messagesJson != null) {
      final messagesData = jsonDecode(messagesJson) as Map<String, dynamic>;
      messagesData.forEach((key, value) {
        _localMessages[key] =
            List<Map<String, dynamic>>.from((value as List).map((item) => {
                  ...Map<String, dynamic>.from(item),
                  'timestamp': DateTime.parse(item['timestamp']),
                }));
      });
    }

    // 저장된 채팅방 로드
    final chatRoomsJson = prefs.getString('chat_rooms');
    if (chatRoomsJson != null) {
      final chatRoomsData = jsonDecode(chatRoomsJson) as Map<String, dynamic>;
      chatRoomsData.forEach((key, value) {
        final roomData = Map<String, dynamic>.from(value);
        roomData['lastMessageTime'] =
            DateTime.parse(roomData['lastMessageTime']);
        roomData['updatedAt'] = DateTime.parse(roomData['updatedAt']);
        _localChatRooms[key] = roomData;
      });
    }

    _isInitialized = true;

    // 주기적 업데이트 타이머 시작 (1초마다)
    _periodicTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      _messageController.add('refresh');
    });
  }

  // 데이터 저장
  static Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // 메시지 저장 (timestamp를 문자열로 변환)
    final messagesForSave = <String, dynamic>{};
    _localMessages.forEach((key, value) {
      messagesForSave[key] = value
          .map((message) => {
                ...message,
                'timestamp':
                    (message['timestamp'] as DateTime).toIso8601String(),
              })
          .toList();
    });
    await prefs.setString('chat_messages', jsonEncode(messagesForSave));

    // 채팅방 저장
    final chatRoomsForSave = <String, dynamic>{};
    _localChatRooms.forEach((key, value) {
      chatRoomsForSave[key] = {
        ...value,
        'lastMessageTime':
            (value['lastMessageTime'] as DateTime).toIso8601String(),
        'updatedAt': (value['updatedAt'] as DateTime).toIso8601String(),
      };
    });
    await prefs.setString('chat_rooms', jsonEncode(chatRoomsForSave));
  }

  // 채팅방 생성 또는 가져오기
  // 1:1 계정 기준 채팅방 ID 생성
  String getChatRoomId(String email, String otherEmail, String itemId) {
    // 두 email을 정렬해서 항상 같은 채팅방 ID 생성, 상품ID도 포함
    List<String> users = [email, otherEmail];
    users.sort();
    final chatRoomId = 'chat_${itemId}_${users[0]}_${users[1]}';
    print(
        'getChatRoomId: email=$email, otherEmail=$otherEmail, itemId=$itemId → chatRoomId=$chatRoomId');
    return chatRoomId;
  }

  // 메시지 전송
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderEmail,
    required String senderName,
    required String message,
    required Map<String, dynamic> itemInfo,
    required String otherEmail,
  }) async {
    await _initialize(); // 초기화

    final messageData = {
      'senderId': senderEmail,
      'senderName': senderName,
      'message': message,
      'timestamp': DateTime.now(),
      'type': 'text',
      'readBy': [senderEmail], // 보낸 사람은 바로 읽음 처리
    };

    if (!_localMessages.containsKey(chatRoomId)) {
      _localMessages[chatRoomId] = [];
    }
    _localMessages[chatRoomId]!.add(messageData);

    _localChatRooms[chatRoomId] = {
      'participants': [senderEmail, otherEmail],
      'lastMessage': message,
      'lastMessageTime': DateTime.now(),
      'itemInfo': itemInfo,
      'updatedAt': DateTime.now(),
    };

    await _saveData(); // 데이터 저장

    // 스트림 업데이트
    _messageController.add(chatRoomId);
  }

  // 해당 채팅방의 모든 메시지를 내 이메일 기준으로 읽음 처리
  Future<void> markMessagesAsRead(String chatRoomId, String myEmail) async {
    await _initialize();
    final messages = _localMessages[chatRoomId];
    if (messages == null) return;
    bool updated = false;
    for (final msg in messages) {
      if (!(msg['readBy'] is List)) {
        msg['readBy'] = [];
      }
      if (!(msg['readBy'] as List).contains(myEmail)) {
        (msg['readBy'] as List).add(myEmail);
        updated = true;
      }
    }
    if (updated) {
      await _saveData();
      _messageController.add(chatRoomId);
    }
  }

  // 메시지 실시간 스트림
  Stream<List<Map<String, dynamic>>> getMessages(String chatRoomId) async* {
    await _initialize(); // 초기화

    // 초기 데이터 제공
    yield _localMessages[chatRoomId] ?? [];

    // 실시간 업데이트 스트림
    await for (final updatedChatRoomId in _messageController.stream) {
      if (updatedChatRoomId == chatRoomId) {
        yield _localMessages[chatRoomId] ?? [];
      }
    }
  }

  // 사용자의 채팅방 목록 가져오기
  Stream<List<Map<String, dynamic>>> getUserChatRooms(String email) async* {
    await _initialize(); // 초기화

    // 초기 데이터 제공
    final initialRooms = _localChatRooms.entries
        .where((entry) => (entry.value['participants'] as List).contains(email))
        .map((entry) => {
              'id': entry.key,
              ...entry.value,
            })
        .toList()
      ..sort((a, b) => (b['lastMessageTime'] as DateTime)
          .compareTo(a['lastMessageTime'] as DateTime));
    yield initialRooms;

    // 실시간 업데이트 스트림
    await for (final _ in _messageController.stream) {
      final rooms = _localChatRooms.entries
          .where(
              (entry) => (entry.value['participants'] as List).contains(email))
          .map((entry) => {
                'id': entry.key,
                ...entry.value,
              })
          .toList()
        ..sort((a, b) => (b['lastMessageTime'] as DateTime)
            .compareTo(a['lastMessageTime'] as DateTime));
      yield rooms;
    }
  }

  // 채팅방 정보 가져오기
  Future<Map<String, dynamic>?> getChatRoomInfo(String chatRoomId) async {
    await _initialize(); // 초기화
    return _localChatRooms[chatRoomId];
  }

  // 모든 채팅 데이터 초기화
  static Future<void> clearAllChatData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_messages');
    await prefs.remove('chat_rooms');
    _localMessages.clear();
    _localChatRooms.clear();
    _messageController.add('refresh');
    print('모든 채팅 데이터가 초기화되었습니다.');
  }
}

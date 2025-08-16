import 'package:flutter/material.dart';
import '../../services/local_chat_service.dart';
import '../../global.dart';
import '../../services/local_chat_service.dart';
import 'chat_screen.dart';
import '../../global.dart';
import '../../db_helper.dart';

class ChatListScreen extends StatefulWidget {
  final String? filterItemId;
  const ChatListScreen({super.key, this.filterItemId});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late final ChatService _chatService;
  late final String _currentEmail;

  @override
  void initState() {
    super.initState();
    _chatService = ChatService();
    _currentEmail = userEmail.value ?? '';
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';

    DateTime time;
    if (timestamp is DateTime) {
      time = timestamp;
    } else if (timestamp is int) {
      time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return '방금';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${time.month}/${time.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('채팅',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          // 전체 안읽은 메시지 뱃지 등 필요시 여기에 추가
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatService.getUserChatRooms(_currentEmail),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('오류가 발생했습니다.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final chatRooms = snapshot.data ?? [];
          // 상품ID로 필터링 (판매자 '채팅보기'에서만)
          final filteredRooms = widget.filterItemId == null
              ? chatRooms
              : chatRooms
                  .where((room) =>
                      room['itemInfo']?['itemId']?.toString() ==
                      widget.filterItemId.toString())
                  .toList();

          if (filteredRooms.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    '아직 채팅이 없습니다.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '상품에서 채팅하기를 눌러보세요!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredRooms.length,
            itemBuilder: (context, index) {
              final chatRoomData = filteredRooms[index];
              final itemInfo =
                  chatRoomData['itemInfo'] as Map<String, dynamic>? ?? {};
              final participants =
                  List<String>.from(chatRoomData['participants'] ?? []);
              final otherEmail = participants.firstWhere(
                (email) => email != _currentEmail,
                orElse: () => 'Unknown',
              );
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                elevation: 1,
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  tileColor: Colors.white,
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: FutureBuilder<Map<String, dynamic>?>(
                          future: DBHelper.getUserByUsernameOrEmail(otherEmail),
                          builder: (context, snapshot) {
                            String displayName = otherEmail;
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.data != null) {
                              final user = snapshot.data!;
                              if (user['name'] != null &&
                                  user['name'].toString().isNotEmpty) {
                                displayName = user['name'];
                              }
                            }
                            if (otherEmail == itemInfo['sellerId']) {
                              displayName = '판매자';
                            }
                            return Text(
                              displayName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            );
                          },
                        ),
                      ),
                      Text(
                        _formatTimestamp(chatRoomData['lastMessageTime']),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        itemInfo['title'] ?? '상품 정보 없음',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chatRoomData['lastMessage'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  trailing: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: itemInfo['images'] != null &&
                                (itemInfo['images'] as List).isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  itemInfo['images'][0],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image,
                                          color: Colors.grey),
                                ),
                              )
                            : const Icon(Icons.image, color: Colors.grey),
                      ),
                      // 채팅방별 unread badge
                      Positioned(
                        right: -2,
                        top: -2,
                        child: StreamBuilder<List<Map<String, dynamic>>>(
                          stream: _chatService.getMessages(chatRoomData['id']),
                          builder: (context, msgSnapshot) {
                            final myEmail = _currentEmail;
                            if (!msgSnapshot.hasData)
                              return const SizedBox.shrink();
                            final messages = msgSnapshot.data!;
                            final unreadCount = messages
                                .where((msg) =>
                                    msg['senderId'] != myEmail &&
                                    (!(msg['readBy'] is List) ||
                                        !(msg['readBy'] as List)
                                            .contains(myEmail)))
                                .length;
                            if (unreadCount == 0)
                              return const SizedBox.shrink();
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.white, width: 1),
                              ),
                              child: Text(
                                '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // 채팅 화면으로 이동 (상대방 userId를 명시적으로 전달)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          item: {
                            'id': itemInfo['itemId'],
                            'title': itemInfo['title'],
                            'price': itemInfo['price'],
                            'author': itemInfo['sellerId'],
                            'images': itemInfo['images'],
                          },
                          sellerName: otherEmail == itemInfo['sellerId']
                              ? '판매자'
                              : otherEmail,
                          otherUserId: otherEmail,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

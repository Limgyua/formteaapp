import 'package:flutter/material.dart';
import '../../services/local_chat_service.dart';
import '../../global.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  final String sellerName;

  const ChatScreen({
    super.key,
    required this.item,
    required this.sellerName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  String get _currentUserId {
    final id = userId.value ?? 'anonymous';
    print(
        '_currentUserId getter called - userId.value: ${userId.value}, returning: $id');
    return id;
  }

  @override
  void initState() {
    super.initState();
    // 채팅방 ID 생성 (build 시점에서 동적으로 생성)
    print(
        'ChatScreen initState - currentUserId: $_currentUserId, userId.value: ${userId.value}');
  }

  String get _chatRoomId {
    final chatRoomId = _chatService.getChatRoomId(
      _currentUserId,
      widget.item['author'] ?? 'seller_001',
      widget.item['id']?.toString() ?? 'item_001',
    );
    print(
        '_chatRoomId 생성: currentUserId=$_currentUserId, author=${widget.item['author']}, itemId=${widget.item['id']}, chatRoomId=$chatRoomId');
    return chatRoomId;
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    _messageController.clear();

    print(
        '_sendMessage - currentUserId: $_currentUserId, userName: ${userName.value}');

    try {
      await _chatService.sendMessage(
        chatRoomId: _chatRoomId,
        senderId: _currentUserId,
        senderName: userName.value ?? _currentUserId,
        message: message,
        itemInfo: {
          'itemId': widget.item['id']?.toString() ?? 'item_001',
          'sellerId': widget.item['author'] ?? 'seller_001',
          'title': widget.item['title'] ?? '',
          'price': widget.item['price'] ?? 0,
          'images': widget.item['images'] != null &&
                  (widget.item['images'] as List).isNotEmpty
              ? [widget.item['images'][0].path]
              : [],
        },
      );
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('메시지 전송에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.grey, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.sellerName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // 더보기 메뉴
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 상품 정보 카드
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: widget.item['images'] != null &&
                            (widget.item['images'] as List).isNotEmpty
                        ? Image.file(
                            widget.item['images'][0],
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item['title'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getFormattedPrice(),
                        style: TextStyle(
                          color: _getFormattedPrice() == '나눔'
                              ? Colors.green
                              : Colors.orange[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 채팅 메시지 리스트
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _chatService.getMessages(_chatRoomId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('오류가 발생했습니다.'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      '메시지를 시작해보세요!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index];
                    final isMe = messageData['senderId'] == _currentUserId;

                    // 상세 디버그 출력
                    print('=== 메시지 정렬 디버그 #$index ===');
                    print(
                        'messageData[senderId]: "${messageData['senderId']}"');
                    print('_currentUserId: "$_currentUserId"');
                    print('userId.value: "${userId.value}"');
                    print('isMe 결과: $isMe');
                    print('메시지 내용: "${messageData['message']}"');
                    print('=============================');

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.orange : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 상대방 메시지인 경우만 이름 표시
                            if (!isMe) ...[
                              Text(
                                messageData['senderName'] ?? 'Unknown',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                            Text(
                              messageData['message'] ?? '',
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatLocalTime(messageData['timestamp']),
                              style: TextStyle(
                                color: isMe
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 메시지 입력 영역
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: '메시지를 입력하세요...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      maxLines: null,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedPrice() {
    final price = widget.item['price'];
    if (price == null || price == 0 || price.toString().trim().isEmpty) {
      return '나눔';
    } else {
      return '${_formatPrice(price)}원';
    }
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '';
    try {
      final intPrice =
          price is int ? price : int.tryParse(price.toString()) ?? 0;
      return intPrice.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    } catch (e) {
      return price.toString();
    }
  }

  String _formatLocalTime(dynamic timestamp) {
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
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.month}/${time.day} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

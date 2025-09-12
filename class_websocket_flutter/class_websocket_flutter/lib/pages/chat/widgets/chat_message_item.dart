import 'package:class_websocket_flutter/data/models/chat_message.dart';
import 'package:flutter/material.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;
  final String currentUsername;

  const ChatMessageItem({
    required this.message,
    required this.currentUsername,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isSystemMessage) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade300, //Colors.grey[300]
              borderRadius: BorderRadius.circular(12),
            ),
            // 시스템 메세지
            child: Text(
              message.content,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
        ),
      );
    }

    // 내 메세지 or 다른 사람 메세지
    final isMyMessage = message.isMyMessage(currentUsername);

    if (isMyMessage) {
      // 나의 메세지
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // 말풍선 위젯
            // Expanded - 전체 공간을 차지 (클수 있을 만큼)
            // Flexible - 필요한 만큼 차지 (보통 Container 와 많이 활용)
            Flexible(
              child: Container(
                // 컨테이너 위젯에 제약 조건을 설정하는 속성
                constraints: BoxConstraints(
                  minWidth: 60,
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.content,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              message.formattedTime,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    } else {
      // 다른 사람 메세지
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              message.formattedTime,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            // 말풍선 위젯
            // Expanded - 전체 공간을 차지 (클수 있을 만큼)
            // Flexible - 필요한 만큼 차지 (보통 Container 와 많이 활용)
            Flexible(
              child: Container(
                // 컨테이너 위젯에 제약 조건을 설정하는 속성
                constraints: BoxConstraints(
                  minWidth: 60,
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      message.sender,
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      message.content,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

import 'package:class_websocket_flutter/providers/local/connection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatInputField extends ConsumerWidget {
  final TextEditingController controller;
  final VoidCallback onSendMessage;

  const ChatInputField({
    required this.controller,
    required this.onSendMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(connectedStateProvider);

    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: '메세지를 입력하세요',
                border: OutlineInputBorder(),
              ),
              // 엔터키 입력 시 처리됨 : 키보드의 완료 / 전송 버튼 터치시 동작 함
              onSubmitted: (value) => onSendMessage(),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: connection.isConnected == true ? onSendMessage : null,
            child: Text('전송'),
          )
        ],
      ),
    );
  }
}

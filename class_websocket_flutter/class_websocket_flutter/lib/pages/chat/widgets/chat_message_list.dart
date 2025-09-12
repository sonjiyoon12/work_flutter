import 'package:class_websocket_flutter/pages/chat/widgets/chat_message_item.dart';
import 'package:class_websocket_flutter/providers/local/chat_message_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessageList extends ConsumerWidget {
  // 외부에서 주입 받는 스크롤 컨트롤러
  // 상위 위젯에서 자동 스크롤 기능을 제어하기 위해 필요
  final ScrollController scrollController;

  const ChatMessageList({required this.scrollController, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 상태 구독
    final ChatState chatState = ref.watch(chatMessageProvider);
    // ListView() <-- 데이터 100개 있으면 다 나타냄
    return ListView.builder(
      controller: scrollController,
      itemCount: chatState.messages.length,
      itemBuilder: (context, index) {
        return ChatMessageItem(
          message: chatState.messages[index],
          currentUsername: chatState.username,
        );
      },
    );
  }
}

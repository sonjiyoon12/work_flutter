import 'package:class_websocket_flutter/pages/chat/widgets/chat_connection_status.dart';
import 'package:class_websocket_flutter/pages/chat/widgets/chat_input_field.dart';
import 'package:class_websocket_flutter/pages/chat/widgets/chat_message_list.dart';
import 'package:class_websocket_flutter/providers/local/chat_message_provider.dart';
import 'package:class_websocket_flutter/providers/local/connection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatBody extends ConsumerStatefulWidget {
  const ChatBody({super.key});

  @override
  ConsumerState<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends ConsumerState<ChatBody> {
  final TextEditingController _editingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 위젯이 안정적으로 바인딩 된 후에 ref 호출
      ref.read(connectedStateProvider.notifier).connect();
    });
  }

  // 메모리 해제
  @override
  void dispose() {
    _editingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 메세지 전송
  void _sendMessage() {
    final content = _editingController.text;
    if (content.isEmpty) return;
    _editingController.clear();

    // 기능 호출 한번만
    ref.read(chatMessageProvider.notifier).sendMessage(content);
  }

  void _scrollToBottom() {
    // 이 위젯이 완전히 렌더링 된 시점에 한번만 콜백을 실행하도록 보장
    // 위젯의 크기나 위치 정보가 정확히 확정된 시점에 네트워크 연결 또는
    // 안정적인 동작을 보장
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen() - 상태가 변경될 때 특정 로직만 실행 (UI 재구축이랑 별개)
    ref.listen<ChatState>(
      chatMessageProvider,
      (previous, next) {
        if (previous != null &&
            previous.messages.length < next.messages.length) {
          // 자동 스크롤 내리는 기능
          _scrollToBottom();
        }
      },
    );

    return Column(
      children: [
        ChatConnectionStatus(),
        // ListView
        Expanded(child: ChatMessageList(scrollController: _scrollController)),
        ChatInputField(
            controller: _editingController, onSendMessage: _sendMessage)
      ],
    );
  }
}

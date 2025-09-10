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

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

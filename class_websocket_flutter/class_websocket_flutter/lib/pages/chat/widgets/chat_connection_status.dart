import 'package:class_websocket_flutter/providers/local/connection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatConnectionStatus extends ConsumerWidget {
  const ChatConnectionStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 상태 감지 기능
    final connection = ref.watch(connectedStateProvider);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.0),
      // 동적 컬러 설정
      color: connection.isConnected ? Colors.green : Colors.red,
      child: Text(
        '${connection.status}',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}

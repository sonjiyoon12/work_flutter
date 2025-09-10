import 'package:class_websocket_flutter/pages/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // ProviderScope 리버팟에서 제공하는 위젯들을 제공한다.
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'stomp chat',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        // 최신 머터리얼 디자인 사용 선언
        useMaterial3: true,
      ),
      home: const ChatPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

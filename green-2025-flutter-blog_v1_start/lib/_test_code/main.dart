import 'package:flutter/material.dart';
import 'package:flutter_blog/_test_code/shopping_app.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // 플러터 왕국에 리버팟 창고 시스템 도입
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '리버팟',
      home: ShoppingApp(),
    );
  }
}

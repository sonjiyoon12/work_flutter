import 'package:flutter/material.dart';
import 'package:flutter_blog/providers/global/session_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    // 앱 시작후 자동 로그인 프로세스 시작
    _performAutoLogin();
  }

  void _performAutoLogin() async {
    // 1
    // 오토 로그인 요청
    // 결과에 따라서 로그인 페이지, 게시글 목록 페이지
    // 혹시 오류 발생 했다면 로그인 페이지
    final auto = await ref.read(sessionProvider.notifier).autoLogin();
    if (auto) {
      await Future.delayed(Duration(seconds: 2), () {
        Navigator.pushNamed(context, "/post/list");
      });
    } else {
      await Future.delayed(Duration(seconds: 2), () {
        Navigator.pushNamed(context, "/login");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/splash.gif',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/login");
        },
        child: Icon(Icons.arrow_circle_right),
      ),
    );
  }
}

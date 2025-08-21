// 세션 이라는 데이터를 구조화 해보자
// 창고 데이터 구상하기

import 'package:flutter/material.dart'
    show ScaffoldMessenger, Text, SnackBar, Navigator;
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/models/repository/user_repository.dart';
import 'package:flutter_blog/data/models/user.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_blog/providers/form/join_form_notifier.dart';
import 'package:flutter_blog/providers/form/login_form_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class SessionModel {
  User? user;
  bool? isLogin;

  SessionModel({this.user, this.isLogin = false});

  @override
  String toString() {
    return 'SessionModel{user: $user, isLogin: $isLogin}';
  }
}

// 창고 매뉴얼
class SessionNotifier extends Notifier<SessionModel> {
  // context가 없는 환경에서 네비게이션과 알림 처리를 위한 전역 키이다.
  final mContext = navigatorKey.currentContext!;

  @override
  SessionModel build() {
    return SessionModel();
  }

  // 로그인 로직 설계
  Future<void> login(String username, String password) async {
    // 유효성 검증 - 사용자가 입력한 username, password
    bool isValid = ref.read(loginFormProvider.notifier).validate();
    if (isValid == false) {
      ScaffoldMessenger.of(mContext)
          .showSnackBar(SnackBar(content: Text("유효성 검사 실패")));
      return;
    }
    Map<String, dynamic> body =
        await UserRepository().login(username, password);
    if (body["success"] == false) {
      ScaffoldMessenger.of(mContext)
          .showSnackBar(SnackBar(content: Text("로그인 실패")));
      return;
    }
    // 서버에서 받은 사용자 정보를 앱에서 사용할 수 있는 형태로 변환
    // Map 구조에서 ---> 파싱 ---> Object 파싱 처리 함 왜???

    User user = User.fromMap(body["response"]);

    // 로컬 저장소에 JWT 토큰을 저장해 두자.
    // sharedPreferences 보안에 강화된 녀석 // yml 라이브러리 선언 됨
    await secureStorage.write(key: "accessToken", value: user.accessToken);

    state = SessionModel(user: user, isLogin: true);

    // 로그인 성공 이후에 서버측에 통신 요청할 때마다 JWT 토큰을 주입해야 된다.
    dio.options.headers["Authorization"] = user.accessToken;

    //위젯 관련 화면
    Navigator.pushNamed(mContext, "/post/list");
  }

  // 로그 아웃 기능

  // 자동 로그인 기능

  // 회원 가입 로직 추가하기
  Future<void> join(String username, String email, String password) async {
    Logger()
        .d("username : ${username}, email: ${email}, password : ${password}");

    // 한번 더 유효성 검사
    bool isValid = ref.read(joinProvider.notifier).validate();
    if (isValid == false) {
      ScaffoldMessenger.of(mContext)
          .showSnackBar(SnackBar(content: Text("유효성 검사 실패")));
      return;
    }
    Map<String, dynamic> body =
        await UserRepository().join(username, email, password);

    if (body["success"] == false) {
      ScaffoldMessenger.of(mContext)
          .showSnackBar(SnackBar(content: Text(body["errorMessage"])));
      return;
    }

    // 회원 가입 후 로그인 페이지로 이동 처리 (자동 로그인)
    Navigator.pushNamed(mContext, "/login");
  }
} // end of SessionNotifier

// 실제 창고 개설
final sessionProvider =
    NotifierProvider<SessionNotifier, SessionModel>(() => SessionNotifier());

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

// 문제점 고민해보기
// 1. 책임 혼재 : UI 로직 + 비즈니스 로직 + 검증 로직 중복
// 2. 테스트 어려움 : UI 와 비즈니스 로직이 동시에 존재해서 관리 어려움
// 3. 재사용성 저하 : 다른 화면에서 로그인 로직 재사용 어려움
// 창고 매뉴얼
class SessionNotifier extends Notifier<SessionModel> {
  @override
  SessionModel build() {
    return SessionModel();
  }

  // 로그인 로직 설계 - 비즈니스 로직에 집중
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      Map<String, dynamic> body =
          await UserRepository().login(username, password);

      if (body["success"] == false) {
        return body; // 서버에서 내려준 에러 정보를 그대로 반환 --> UI 측으로
      }

      // 서버에서 받은 사용자 정보를 앱에서 사용할 수 있는 형태로 변환
      // Map 구조에서 ---> 파싱 ---> Object 파싱 처리 함 왜???
      User user = User.fromMap(body["response"]);

      // 로컬 저장소에 JWT 토큰을 저장해 두자.
      // sharedPreferences에 보안이 강화된 녀석 // yml 라이브러리 선언 됨
      await secureStorage.write(key: "accessToken", value: user.accessToken);

      state = SessionModel(user: user, isLogin: true);

      // 로그인 성공 이후에 서버측에 통신 요청할 때마다 JWT 토큰을 주입해야 된다.
      dio.options.headers["Authorization"] = user.accessToken;

      return {"success": true}; // 로그인 성공 정보 반환
    } catch (e) {
      // 네트 워크 장애
      return {"success": false, "errorMessage": "네트워크 오류 발생했습니다"};
    }
  }

  // 로그 아웃 기능
  Future<void> logout() async {
    try {
      await secureStorage.delete(key: "accessToken");
      state = SessionModel();
      dio.options.headers["Authorization"] = "";
      Logger().d("로그아웃 종료");
    } catch (e) {
      Logger().d("로그아웃 중 오류 발생");
      state = SessionModel();
      dio.options.headers["Authorization"] = "";
    }
  }

  // 자동 로그인 기능
  Future<bool> autoLogin() async {
    try {
      // 1단계 : 저장소에서 인증 토큰 확인
      String? accessToken = await secureStorage.read(key: "accessToken");
      if (accessToken == null) {
        return false;
      }
      // 2단계 : UsrRepository() 에게 자동 로그인 요청
      Map<String, dynamic> body = await UserRepository().autoLogin(accessToken);

      // 3단계 : 서버에서 받은 사용자 정보를 창고에 다시 넣어야 한다
      User user = User.fromMap(body["response"]);
      user.accessToken = accessToken;

      // 4단계 : 창고 데이터에 로그인된 상태로 업데이트 처리
      state = SessionModel(user: user, isLogin: true);

      // 5단계 : 이 후 모든 HTTP 요청에 인증 열쇠 자동 부여 하기
      dio.options.headers["Authorization"] = user.accessToken;
      Logger().d("자동 로그인 성공");
      return true;
    } catch (e) {
      Logger().d("자동 로그인 중 오류 발생 : ${e}");
      return false;
    }
  }

  // 회원 가입 로직 추가하기
  Future<Map<String, dynamic>> join(
      String username, String email, String password) async {
    Logger()
        .d("username : ${username}, email: ${email}, password : ${password}");

    Map<String, dynamic> body =
        await UserRepository().join(username, email, password);

    // 회원 가입 실패 시 처리
    if (body["success"] == false) {
      return {"success": false, "errorMessage": body["errorMessage"]};
    } else {
      return {"success": true};
    }
  }
} // end of SessionNotifier

// 실제 창고 개설
final sessionProvider =
    NotifierProvider<SessionNotifier, SessionModel>(() => SessionNotifier());

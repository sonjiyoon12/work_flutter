import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:logger/logger.dart';

class UserRepository {
  // 회원 가입 요청 - post 요청
  Future<Map<String, dynamic>> join(
      String username, String email, String password) async {
    // 1. 요청 데이터 구성 - map 구조로 설계
    final requestBody = {
      "username": username,
      "email": email,
      "password": password,
    };
    // 2. HTTP post 요청
    Response response = await dio.post("/join", data: requestBody);
    // 3. 응답 처리
    final responseBody = response.data; // body 데이터 모두
    Logger().d(responseBody); // 개발용 로깅 처리
    // 4. 리턴
    return responseBody;
  }

  // 로그인 요청 - http 통신을 하고 문자열(json) 받아서 -- Map 구조로 파싱 처리 까지 책임
  Future<Map<String, dynamic>> login(String username, String password) async {
    final requestBody = {
      "username": username,
      "password": password,
    };

    Response response = await dio.post("/login", data: requestBody);

    Map<String, dynamic> responseBody = response.data;
    // 개발 로깅용
    Logger().d(responseBody);
    return responseBody;
  }

  // 자동 로그인 - 토큰 값이 유효하다면
  Future<Map<String, dynamic>> autoLogin(String accessToken) async {
    Response response = await dio.post(
      "/auto/login",
      options: Options(
        headers: {
          "Authorization": accessToken,
        },
      ),
    );
    Map<String, dynamic> responseBody = response.data;
    Logger().e(responseBody);
    return responseBody;
  }
}

// // 테스트용 코드
// void main() {
//   // Android 9 버전 이후부터 통신은 HTTPS만 허용하게 기본 설정 됨
//   //UserRepository().join('test222', 't3@naver.com', '1234');
//   // UserRepository().login("ssar", "1234");
//   UserRepository().autoLogin(
//       "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpbWdVcmwiOiIvaW1hZ2VzLzEucG5nIiwic3ViIjoibWV0YWNvZGluZyIsImlkIjoxLCJleHAiOjE3NTU3NTY3MTMsInVzZXJuYW1lIjoic3NhciJ9.6C8hiAyIiwwW9qUH4qBG8dmi_7aqepPVKmv9PGYh2qHTDItr4jbv064xrdV4_LpLiHShTgOsbLhH8abAFYS-sA");
// }

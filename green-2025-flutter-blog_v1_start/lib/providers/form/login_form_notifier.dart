// 창고 데이터 설계
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../_core/utils/validator_util.dart';

class LoginModel {
  // 각 필드 사용자 입력값 관리 변수
  final String username;
  final String password;

  // 각 입력 필드 검증 에러 메세지 관리 변수
  final String usernameError;
  final String passwordError;

  LoginModel(
    this.username,
    this.password,
    this.usernameError,
    this.passwordError,
  );

  // 기존 데이터에서 일부 변경한 값만 받아서 새로운 객체 만드는 코드 작성
  // LoginModel loginModel = LoginModel("홍")
  // loginModel.password ="1234";
  // LoginModel() = loginModel.copyWith(usernameError : "3글자 이상 입력");
  // LoginModel() = state.copyWith(usernameError: "특수문자 안됨");

  // void main() {
  //   LoginModel loginModel = LoginModel("홍", "1234", "3글자 이상 입력", "4글자 입상 입력");
  //   LoginModel loginModel2 = LoginModel(loginModel.username, loginModel.password, "특수 문자 안됨", loginModel.passwordError);
  //   loginModel.copyWith(usernameError: "특수문자 안됨");
  // }
  LoginModel copyWith(
      {String? username,
      String? password,
      String? usernameError,
      String? passwordError}) {
    return LoginModel(
      username ?? this.username,
      password ?? this.password,
      usernameError ?? this.usernameError,
      passwordError ?? this.passwordError,
    );
  }

  // 디버그 용
  @override
  String toString() {
    return 'LoginModel{username: $username, password: $password, usernameError: $usernameError, passwordError: $passwordError}';
  }
} // emd of loginModel class

// 창고 매뉴얼 설계 - 비즈니스 로직 + 상태
class LoginFormNotifier extends Notifier<LoginModel> {
  // 반드시 이 값이 필요하다는 강제성 부여
  @override
  LoginModel build() {
    return LoginModel("", "", "", "");
  }

  // 사용자명 입력시 : 즉시 검증 + 상태 업데이트 기능 구현
  void username(String username) {
    final String error = validateUsername(username);
    Logger().d(error);

    state = state.copyWith(
      username: username,
      usernameError: error,
    );
  }

  // 비밀번호 입력시 : 즉시 검증 + 상태 업데이트 기능 구현
  void password(String password) {
    final String passwordError = validatePassword(password);

    if (passwordError.trim().isEmpty) {
      Logger().d(password);
    } else {
      Logger().e(passwordError);
    }

    state = state.copyWith(
      password: password,
      passwordError: passwordError,
    );
  }

  bool validate() {
    final usernameError = validateUsername(state.username);
    final passwordError = validateUsername(state.password);

    return usernameError.isEmpty && passwordError.isEmpty;
  }
} // end of LoginFormNotifier

// 실제 창고를 메모리에 올리자 - 전역 변수로 관리
final loginFormProvider =
    NotifierProvider<LoginFormNotifier, LoginModel>(() => LoginFormNotifier());
// loginFormProvider --> LoginFormNotifier() --> LoginModel()
// ref.read(loginFormProvider);    --> LoginModel()
// ref.read(loginFormProvider.notifier); --> LoginFormNotifier()

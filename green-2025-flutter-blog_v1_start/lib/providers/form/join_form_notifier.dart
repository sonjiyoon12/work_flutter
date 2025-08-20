// 복합 창고 설계할 예정

// 1.1 회원 가입 폼 모델 부터 설계(어떤 데이터를 관리할지 설계)
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// 상태 결정
class JoinModel {
  final String username;
  final String email;
  final String password;

  // 각 필드의 검증 애러 메세지
  final String usernameError;
  final String emailError;
  final String passwordError;

  JoinModel({
    required this.username,
    required this.email,
    required this.password,
    required this.usernameError,
    required this.emailError,
    required this.passwordError,
  });

  // 불면 객체에서 일부만 변경한 새 객체 생성 편의 기능
  JoinModel copyWith({
    String? username, // null 이면 기존 값 유지, 값이 주어지면 변경
    String? email,
    String? password,
    String? usernameError,
    String? emailError,
    String? passwordError,
  }) {
    return JoinModel(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      usernameError: usernameError ?? this.usernameError,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
    );
  }

  // 개발용 디버그 코드
  @override
  String toString() {
    return 'JoinModel{username: $username, email: $email, password: $password, usernameError: $usernameError, emailError: $emailError, passwordError: $passwordError}';
  }
}

/// 1.2 창고 매뉴얼 설계
class JoinFormNotifier extends Notifier<JoinModel> {
  // 초기 상태값을 명시해주어야 한다.
  @override
  JoinModel build() {
    return JoinModel(
      username: "",
      email: "",
      password: "",
      usernameError: "",
      emailError: "",
      passwordError: "",
    );
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

  // 이메일 입력시 : 즉시 검증 + 상태 업데이트 기능 구현
  void email(String email) {
    final String error = validateEmail(email);
    Logger().d(error);

    state = state.copyWith(
      email: email,
      emailError: error,
    );
  }

  // 비밀번호 입력시 : 즉시 검증 + 상태 업데이트 기능 구현
  void password(String password) {
    final String error = validatePassword(password);
    Logger().d(error);

    state = state.copyWith(
      password: password,
      passwordError: error,
    );
  }

  // 최종 검증 - 회원 가입 버튼 누를 때 동작 처리
}

// 1.3 실제 창고 개설
final joinProvider =
    NotifierProvider<JoinFormNotifier, JoinModel>(() => JoinFormNotifier());

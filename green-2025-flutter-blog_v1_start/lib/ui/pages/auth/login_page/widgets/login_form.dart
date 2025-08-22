import 'package:flutter/material.dart';
import 'package:flutter_blog/providers/form/login_form_notifier.dart';
import 'package:flutter_blog/providers/global/session_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../_core/constants/size.dart';
import '../../../../widgets/custom_auth_text_form_field.dart';
import '../../../../widgets/custom_elavated_button.dart';
import '../../../../widgets/custom_text_button.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LoginModel loginModel = ref.watch(loginFormProvider);
    LoginFormNotifier loginFormNotifier = ref.read(loginFormProvider.notifier);
    return Form(
        child: Column(
      children: [
        CustomAuthTextFormField(
          title: "Username",
          errorText: loginModel.usernameError,
          onChanged: (value) {
            loginFormNotifier.username(value);
          },
        ),
        const SizedBox(height: mediumGap),
        CustomAuthTextFormField(
          title: "Password",
          errorText: loginModel.passwordError,
          onChanged: (value) {
            loginFormNotifier.password(value);
          },
          obscureText: true,
        ),
        const SizedBox(height: largeGap),
        CustomElevatedButton(
          text: "로그인",
          click: () async {
            // 검증
            bool isValid = loginFormNotifier.validate();
            if (isValid == false) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("유효성 검사 실패")));
              return;
            }

            final result = await ref.read(sessionProvider.notifier).login(
                  loginModel.username,
                  loginModel.password,
                );
            if (result["success"] == false) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result["errorMessage"])));
            } else {
              // 로그인 성공시 게시글 목록 화면으로 이동
              Navigator.pushNamed(context, "/post/list");
              // Navigator.popAndPushNamed(context, "/post/list");
            }
          },
        ),
        CustomTextButton(
          text: "회원가입 페이지로 이동",
          click: () {
            Navigator.pushNamed(context, "/join");
          },
        ),
      ],
    ));
  }
}

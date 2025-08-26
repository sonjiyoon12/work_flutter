import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  // 비활성화 기능 추가하기 위해서 nullable 변경 처리 함.
  // 중복 클릭 방지 용
  final VoidCallback? click;

  CustomTextButton({required this.text, required this.click});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: click,
      child: Text(text,
          style: const TextStyle(
              color: Colors.black87, decoration: TextDecoration.underline)),
    );
  }
}

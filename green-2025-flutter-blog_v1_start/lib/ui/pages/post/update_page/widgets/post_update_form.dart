import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_blog/providers/global/post/post_update_notifier.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostUpdateForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

  PostUpdateForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PostUpdateModel model = ref.watch(postUpdateProvider);
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          CustomTextFormField(
            controller: _title,
            initValue: "제목",
            hint: "Title",
            validator: (value) =>
                value?.trim().isEmpty == true ? "제목을 입력하세요" : null,
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            controller: _content,
            hint: "Content",
            validator: (value) =>
                value?.trim().isEmpty == true ? "내용을 입력해주세요" : null,
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "글 수정하기",
            click: () {},
          ),
        ],
      ),
    );
  }
}

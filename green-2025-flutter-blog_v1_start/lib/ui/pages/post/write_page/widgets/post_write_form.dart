import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_blog/providers/global/post/post_write_notifier.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostWriteForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

  PostWriteForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostWriteModel? postWriteModel = ref.watch(posWriteProvider);
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          CustomTextFormField(
            controller: _title,
            hint: "Title",
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            controller: _content,
            hint: "Content",
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "글쓰기",
            click: () async {
              final Map<String, dynamic> result =
                  await ref.read(posWriteProvider.notifier).writePost(
                        _title.text,
                        _content.text,
                      );
              if (result["success"] == false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${result["errorMessage"]}")),
                );
              } else {
                Navigator.pushNamed(context, "/post/list");
              }
            },
          ),
        ],
      ),
    );
  }
}

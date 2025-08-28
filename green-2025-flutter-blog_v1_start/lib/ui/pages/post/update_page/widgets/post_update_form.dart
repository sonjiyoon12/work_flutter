import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/providers/global/post/post_list_notifier.dart';
import 'package:flutter_blog/providers/global/post/post_update_notifier.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_blog/ui/widgets/snackbar_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostUpdateForm extends ConsumerWidget {
  final Post post;
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

  PostUpdateForm(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PostUpdateModel model = ref.watch(postUpdateProvider);

    ref.listen<PostUpdateModel>(
      postUpdateProvider,
      (previous, next) {
        if (next.isLoading == false && next.error == null) {
          // 사이드 이펙트 1
          SnackBarUtil.showSuccess(context, "게시글 수정 완료");

          // 게시글 상세보기 갱신
          // 게시글 목록보기 갱신
          ref.read(postListProvider.notifier).refreshAfterWriter();

          Navigator.of(context).pop();
          Navigator.of(context).pop();

          // 뒤로 뒤로 /
          // 한번에 화면 이동 하고 (스택 제거 처리)
        }
      },
    );

    /// ref.read() 한번 읽어서 기능 호출
    /// ref.watch() 계속 감시
    /// ref.listen() - 사이드 이펙트(ref 통신)
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          CustomTextFormField(
            controller: _title,
            initValue: post.title,
            hint: "Title",
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            initValue: post.content,
            controller: _content,
            hint: "Content",
          ),
          const SizedBox(height: largeGap),
          // 중복 클릭 방지
          CustomElevatedButton(
            text: model.isLoading == true ? "수정중.." : "글 수정하기",
            click: model.isLoading == true
                ? null
                : () => _handleUpdate(ref, context),
          ),
        ],
      ),
    );
  } // end of build

  void _handleUpdate(WidgetRef ref, BuildContext context) async {
    try {
      // 1. 폼 유효성 검사
      if (_formKey.currentState!.validate() == false) {
        return;
      }

      Post updatedPost = post.copyWith(
        title: _title.text.trim(),
        content: _content.text,
      );

      await ref.read(postUpdateProvider.notifier).updatePost(updatedPost);
    } catch (e) {
      SnackBarUtil.showError(context, "수정 중 오류 발생");
    }
  }
}

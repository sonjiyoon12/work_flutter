import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/utils/permission_util.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/providers/global/post/post_detail_notifier.dart';
import 'package:flutter_blog/providers/global/post/post_list_notifier.dart';
import 'package:flutter_blog/providers/global/session_notifier.dart';
import 'package:flutter_blog/ui/pages/post/update_page/post_update_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailButtons extends ConsumerWidget {
  final Post post;

  const PostDetailButtons(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SessionModel sessionModel = ref.read(sessionProvider);
    final currentUser = sessionModel.user;

    bool canEdit = PermissionUtil.canEditPost(currentUser, post);
    bool canDelete = PermissionUtil.canDeletePost(currentUser, post);

    if (canEdit == false && canDelete == false) {
      return SizedBox.shrink(); // .(width: 0, height: 0)
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () async {
            _handleDeleteTap(context, ref);
          },
          icon: const Icon(CupertinoIcons.delete),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => PostUpdatePage()));
          },
          icon: const Icon(CupertinoIcons.pen),
        ),
      ],
    );
  } // end of build

  /// 삭제 버튼 클릭 처리
  void _handleDeleteTap(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('게시글 삭제'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('정말로 이 게시글을 삭제하시겠습니까?'),
              const SizedBox(height: 8),
              Text(
                '제목 : ${post.title}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () async {
                // 다이얼 로그 내리고
                Navigator.of(context).pop();
                // 삭제 서비스 로직 요청
                Map<String, dynamic> result = await ref
                    .read(postDetailProvider(post.id).notifier)
                    .deletePost(post.id);
                // 응답 결과 처리
                if (result["success"]) {
                  // mounted = true
                  // 위젯이 dispose 되었을 때 (mounted = false)
                  // 객체는 여전히 존재 하지만 위젯 트리에서 분리된 상태를 말한다.
                  await ref.read(postListProvider.notifier).fetchPosts();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('게시글을 삭제했습니다'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('게시글 삭제 실패'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_blog/providers/global/post/post_list_notifier.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_page.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Stateless + riverPod = ConsumerWidget
// StatefulWidget +riverPod = ConsumerStatefulWidget

// 로컬 UI 상태 변경이 필요한 경우,
// 여러 컨트롤러 객체가 필요한 경우,
// 애니메이션 사용이 필요한 경우
class PostListBody extends ConsumerStatefulWidget {
  const PostListBody({super.key});

  @override
  _PostListBodyState createState() => _PostListBodyState();
}

class _PostListBodyState extends ConsumerState<PostListBody> {
  // 스크롤 위치 감시와 메모리 해제가 필요함
  final ScrollController _scrollController = ScrollController();
  // 추가 로딩 상태 관리
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 10) {
      // 우리가 서버측에 추가 게시글 목록 요청
      if (_isLoadingMore == false) {
        _loadMorePosts();
      }
    }
  }

  Future<void> _loadMorePosts() async {
    // 마지막 페이지라면 추가 요청이 없고 아니라면 추가 요청
    PostListModel? model = ref.read(postListProvider);

    if (model == null || model.isLast) {
      return;
    }
    try {
      _isLoadingMore = true;
      await ref.read(postListProvider.notifier).loadMorePosts();
    } finally {
      _isLoadingMore = false;
    }
  }

  @override
  void dispose() {
    // 메모리 해제가 필요한 경우 많이 활용
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PostListModel? postListModel = ref.watch(postListProvider);
    if (postListModel == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          print("새로고침 기능");
          ref.read(postListProvider.notifier).fetchPosts();
        },
        child: ListView.separated(
          controller: _scrollController,
          itemCount: postListModel.posts.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // 해당 하는 게시글에 PK 값을 전달 해야 해당 정보를 불러올 수 있다.
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            PostDetailPage(postListModel.posts[index].id)));
              },
              child: PostListItem(postListModel.posts[index]),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      );
    }
  }
}

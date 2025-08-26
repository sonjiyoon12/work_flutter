import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/providers/global/post/post_detail_notifier.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_buttons.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_content.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_profile.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ConsumerStatefulWidget 을 선택한 이유 :
// 1. 생명 주기 제어, initState 에서 초기 데이터 로딩
// 2. 중복 로딩 방지 initStates는 단 한번만 호출 됨
// 3. 타이밍 제어 : 안전한 provider 에 접근이 가능하도록 설계 가
class PostDetailBody extends ConsumerStatefulWidget {
  final int postId;
  const PostDetailBody(this.postId, {Key? key}) : super(key: key);

  @override
  ConsumerState<PostDetailBody> createState() => _PostDetailBodyState();
} // end of PostDetailBody

class _PostDetailBodyState extends ConsumerState<PostDetailBody> {
  // 로딩 상태 여부 플래그 변수
  bool _isInitialized = false;

  // 단 한번만 로딩 됨
  @override
  void initState() {
    super.initState();

    /// addPostFrameCallback을 사용하는 이유
    // 1. 안정성 : build 메서드 완료 시 실행 보장
    // 2. 동기화 : Flutter 렌더링 사이클과 맞춤
    // 3. provider 접근 : ref 사용이 안전한 시점에 호출
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _loadInitialData();
      },
    );
  } // end of initState

  void _loadInitialData() {
    if (_isInitialized == false) {
      _isInitialized = true;

      ref
          .read(postDetailProvider(widget.postId).notifier)
          .loadPostDetail(widget.postId);
    }
  }

  // 통신을 통해서 값 가져오고 그리고 렌더링 처리
  @override
  Widget build(BuildContext context) {
    final PostDetailModel? model = ref.watch(postDetailProvider(widget.postId));
    // 1. 초기 상태 또는 로딩 중 (데이터가 없는 상태)
    if (model == null) {
      return Center(child: CircularProgressIndicator());
    }

    // 2. 에러 상태 (네트워크 오류, 서버 오류, 권한 없음 등)
    if (model.error != null) {
      return Container(child: Text("오류 발생 - ${model.error}"));
    }

    // 3. 정상 통신 상태
    return RefreshIndicator(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            // 게시글 제목
            PostDetailTitle(model.post.title),
            const SizedBox(height: largeGap),
            // 작성자 프로필
            PostDetailProfile(model.post),
            const SizedBox(height: smallGap),
            PostDetailButtons(model.post),
            Divider(),
            PostDetailContent(model.post.content),
            // 하단 여백
            SizedBox(height: 40),
          ],
        ),
      ),
      onRefresh: () async {
        await ref
            .read(postDetailProvider(widget.postId).notifier)
            .refresh(widget.postId);
      },
    );
  }
}

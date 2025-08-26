// 통신 관련해서 ---> UI 갱신 로직
// 통신 요청 --> 로딩 -- 성공, 실패

import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/data/models/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class PostDetailModel {
  final Post post;
  final bool isLoading;
  final String? error;

  PostDetailModel({
    required this.post,
    this.isLoading = false,
    this.error,
  });

  // 서버에서 응답 데이터 구조
  // id, title, content, user {id :1, username ...}
  /// json 받아서 파싱 하는 코드 작성 - 네임드 생성자 fromMap(Map<String, dynamic>)
  PostDetailModel.fromMap(Map<String, dynamic> data)
      : post = Post.fromMap(data),
        isLoading = false,
        error = null;

  /// 불변 패턴 사용
  PostDetailModel copyWith({
    Post? post,
    bool? isLoading,
    String? error,
  }) {
    return PostDetailModel(
        post: post ?? this.post,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error);
  }

  @override
  String toString() {
    return 'PostDetailModel{post: $post, isLoading: $isLoading, error: $error}';
  }
} // end of postDetailModel

// 창고 매뉴얼 설계
class PostDetailNotifier
    extends AutoDisposeFamilyNotifier<PostDetailModel?, int> {
  @override
  PostDetailModel? build(int postId) {
    Logger().d("상세보기 화면 id 값 : ${postId}");

    // 개발 디버깅용 코드
    ref.onDispose(
      () {
        Logger().d("postDetailNotifier 파괴된 !! - postId : ${postId}");
      },
    );
    // 초기 값을 null 선언하는 이유는 아직 통신을 통해서 데이터를 안 불러 온 상태
    return null;
  }

  /// 게시글 불러 오기 기능 추가
  Future<void> loadPostDetail(int postId) async {
    try {
      // 1단계 게시글 상세보기 요청
      state = state?.copyWith(isLoading: true, error: null);

      // 2단계
      Map<String, dynamic> response = await PostRepository().getOne(postId);

      // 3단계
      if (response['success']) {
        state = PostDetailModel.fromMap(response['response']);
      } else {
        state = state?.copyWith(error: response['errorMessage']);
      }
    } catch (e) {
      state = state?.copyWith(error: "네트워크 오류 발생");
    }
  }

  /// 게시글 삭제 하는 기능 추가
  Future<Map<String, dynamic>> deletePost(int postId) async {
    // 예외 처리 생략..
    // 1단계
    state = state?.copyWith(isLoading: true, error: null);
    // 2단계
    Map<String, dynamic> response = await PostRepository().deleteOne(postId);
    // 3단계
    if (response['success']) {
      state?.copyWith(isLoading: false);
      return {"success": true};
    } else {
      state?.copyWith(isLoading: false, error: response['errorMessage']);
      return {"success": true, "errorMessage": response["errorMessage"]};
    }
  }

  // 게시글 새로 고침
  Future<void> refresh(int postId) async {
    await loadPostDetail(postId);
  }

  /// 게시글 수정은 화면 이동해서 처리
}

// 2.
final postDetailProvider = AutoDisposeNotifierProvider.family<
    PostDetailNotifier, PostDetailModel?, int>(() => PostDetailNotifier());

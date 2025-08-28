import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/data/models/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// 서버 통신 요청 결과 -->
// 통신 -- 로딩 -- 응답 (성공, 실패)
// 게시글 수정 모델
class PostUpdateModel {
  final bool? isLoading;
  final String? error;
  //final Post? updatePost;

  PostUpdateModel({this.isLoading, this.error});

  // 불변성 패턴
  PostUpdateModel copyWith({bool? isLoading, String? error}) {
    return PostUpdateModel(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'PostUpdateModel{isLoading: $isLoading, error: $error}';
  }
} // end of PostUpdateModel

// 창고 매뉴얼 설계 + 게시글 수정 비즈니스 모델
class PostUpdateNotifier extends AutoDisposeNotifier<PostUpdateModel> {
  // 초기값 지정
  @override
  PostUpdateModel build() {
    ref.onDispose(
      () {
        Logger().d("PostUpdateNotifier 파괴됨");
      },
    );
    return PostUpdateModel();
  }

  Future<Map<String, dynamic>> updatePost(Post post) async {
    try {
      state = state.copyWith(isLoading: true);
      Map<String, dynamic> response = await PostRepository().updateOne(post);
      if (response["success"]) {
        state = state.copyWith(isLoading: false);
        return {"success": true, "message": "게시글이 성공적으로 수정 됨"};
      } else {
        state =
            state.copyWith(isLoading: false, error: response["errorMessage"]);
        return {"success": false, "message": response["errorMessage"]};
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return {"success": false, "message": "수정 중 오류 발생"};
    }
  }
}

final postUpdateProvider =
    AutoDisposeNotifierProvider<PostUpdateNotifier, PostUpdateModel>(
        () => PostUpdateNotifier());

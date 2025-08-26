import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/data/models/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 게시글 수정 진행 상태를 나타내는 열거형
enum PostUpdateStatus {
  initial, // 초기 상태
  loading, // 수정 중
  success, // 수정 성공
  failure // 수정 실패
}

class PostUpdateModel {
  final PostUpdateStatus status; // 수정 진행 상태
  final String? message; // 사용자에게 보여줄 메세지
  final Post? updatedPost; //  수정 성공 시 게시물

  PostUpdateModel({
    this.status = PostUpdateStatus.initial,
    this.message,
    this.updatedPost,
  });

  // 불변성 패턴
  PostUpdateModel copyWith({
    PostUpdateStatus? status,
    String? message,
    Post? updatePost,
  }) {
    return PostUpdateModel(
      status: status ?? this.status,
      message: message ?? this.message,
      updatedPost: updatedPost ?? this.updatedPost,
    );
  }

  @override
  String toString() {
    return 'PostUpdateModel{status: $status, message: $message, updatePost: $updatedPost}';
  }
}

// 창고 매뉴얼 설계 + 순수 비즈니스 로직 담당
class PostUpdateNotifier extends Notifier<PostUpdateModel> {
  @override
  PostUpdateModel build() {
    return PostUpdateModel();
  }

  Future<void> updatePost(Post post) async {
    state = state.copyWith(status: PostUpdateStatus.loading);

    Map<String, dynamic> response = await PostRepository().updateOne(post);

    if (response['success'] == true) {
      Post updatedPost = Post.fromMap(response['response']);
      state = state.copyWith(
        status: PostUpdateStatus.success,
        message: '게시글이 수정되었습니다',
        updatePost: updatedPost,
      );
    } else {
      state = state.copyWith(
        status: PostUpdateStatus.failure,
        message: "${response['errorMessage']} - 게시글 수정에 실패했습니다",
      );
    }
  }
}

final postUpdateProvider =
    NotifierProvider<PostUpdateNotifier, PostUpdateModel>(
        () => PostUpdateNotifier());

import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/data/models/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 게시글 작성 진행 상태를 나타내는 열거형
enum PostWriteStatus {
  initial, // 초기 상태 (아무것도 하지 않은)
  loading, // 작성 중 (서버 통신 중)
  success, // 게시글 작성 성공
  failure // 게시글 작성 실패
}

// 게시글 작성 상태를 설계 (창고 데이터)
class PostWriteModel {
  final PostWriteStatus status; // 현재 게시글 작성 진행 상태
  final String? message; // 사용자에게 보여줄 메세지
  final Post? createdPost; // 작성 성공시 생성된 게시글

  PostWriteModel({
    this.status = PostWriteStatus.initial,
    this.message,
    this.createdPost,
  });

  // 불변성 패턴
  PostWriteModel copyWith({
    PostWriteStatus? status,
    String? message,
    Post? createdPost,
  }) {
    return PostWriteModel(
      status: status ?? this.status,
      message: message ?? this.message,
      createdPost: createdPost ?? this.createdPost,
    );
  }

  @override
  String toString() {
    return 'PostWriteModel{status: $status, message: $message, createdPost: $createdPost}';
  }
} // end of PostWriteModel

// 창고 매뉴얼 설계 + 가능한 순수 비즈니스 로직 담당 (단 SRP - 단일 책임의 원칙)
class PostWriteNotifier extends Notifier<PostWriteModel> {
  @override
  PostWriteModel build() {
    return PostWriteModel();
  }

  Future<void> writePost(String title, String content) async {
    // 기본적으로 try... 사용해야 한다 (서버가 불량인 경우를 위해)
    // 생략..
    // 중복 클릭 방지를 위해서 상태 변경을 한다.
    state = state.copyWith(status: PostWriteStatus.loading);
    // UI 단에서 loading 상태라면 VoidCallback 값을 null 처리하고 비활성화 버튼으로 변경 된다.

    Map<String, dynamic> response =
        await PostRepository().write(title, content);
    if (response['success'] == true) {
      Post createdPost = Post.fromMap(response['response']);
      state = state.copyWith(
        status: PostWriteStatus.success,
        message: "게시글이 작성되었습니다",
        createdPost: createdPost,
      );
    } else {
      state = state.copyWith(
        status: PostWriteStatus.failure,
        message: "${response['errorMessage']} - 게시글 작성에 실패했습니다",
      );
    }
  }
} // end of notifier

final postWriteProvider = NotifierProvider<PostWriteNotifier, PostWriteModel>(
    () => PostWriteNotifier());

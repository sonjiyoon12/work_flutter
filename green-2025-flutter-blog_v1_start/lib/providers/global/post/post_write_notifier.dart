// 게시글 작성

import 'package:flutter_blog/_core/utils/exception_handler.dart';
import 'package:flutter_blog/_test_code/record_test.dart';
import 'package:flutter_blog/data/models/repository/post_repository.dart';
import 'package:flutter_blog/data/models/user.dart';
import 'package:flutter_blog/providers/global/post/post_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostWriteModel {
  int id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  PostWriteModel(
    this.id,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.user,
  );

  PostWriteModel.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        content = data['content'],
        createdAt = data['createdAt'],
        updatedAt = data['updatedAt'],
        user = data['user'];

  PostWriteModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return PostWriteModel(
      id ?? this.id,
      title ?? this.title,
      content ?? this.content,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
      user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'PostWriteModel{id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, user: $user}';
  }
}

class PostWriteNotifier extends Notifier<PostWriteModel?> {
  @override
  PostWriteModel? build() {
    return null;
  }

  // 게시글 작성 로직
  Future<Map<String, dynamic>> writePost(String title, String content) async {
    Map<String, dynamic> body = await PostRepository().write(title, content);
    if (body["success"]) {
      //PostWriteModel newModel = PostWriteModel.fromMap(body["response"]);
      //state = newModel;
      await ref.read(postListProvider.notifier).fetchPosts();
      return {"success": true};
    } else {
      ExceptionHandler.handleException(
          body["errorMessage"], StackTrace.current);
      return {"success": false};
    }
  }
}

final posWriteProvider = NotifierProvider<PostWriteNotifier, PostWriteModel?>(
    () => PostWriteNotifier());

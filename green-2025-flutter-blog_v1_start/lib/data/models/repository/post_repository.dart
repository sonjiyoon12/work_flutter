import 'package:flutter/material.dart'; // main() 실행 시 추
import 'package:dio/dio.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/data/models/repository/user_repository.dart';
import 'package:flutter_blog/data/models/user.dart';
import 'package:logger/logger.dart';

import '../../../_core/utils/my_http.dart';

// TODO - 삭제 예정
void main() {
  // UserRepository().login("ssar", "1234");

  // 임시 테스트 코드
  final _accessToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpbWdVcmwiOiIvaW1hZ2VzLzEucG5nIiwic3ViIjoibWV0YWNvZGluZyIsImlkIjoxLCJleHAiOjE3NTU4MjIwNzAsInVzZXJuYW1lIjoic3NhciJ9.SR7CzF8OmWQTO-LY2KelwOEL9L92aq_vBVD9_59gQj0eb9X-jJw0KPuaU38G5AmKY8xtprLxhllj4zTXQZuYfg";
  dio.options.headers['Authorization'] = 'Bearer $_accessToken';
  // PostRepository().write("테스트글11", "내용내용");
  // PostRepository().getList(page: 2);
  // PostRepository().getOne(1);
  Post post = Post(
    id: 1,
    title: "title 수정",
    content: "content 수정",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    user: User(),
    bookmarkCount: 1,
  );
  // final response = await PostRepository().getOne(2);
  // Post post = Post.fromMap(response["response"]);
  PostRepository().updateOne(post);
}

class PostRepository {
  // 글 작성 요청
  Future<Map<String, dynamic>> write(String title, String content) async {
    // 1. 데이터 준비 - 생략
    // 2. HTTP 요청
    Response response = await dio.post("/api/post", data: {
      "title": title,
      "content": content,
    });

    // 3. 응답 처리
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // 목록 조회 (페이지 네이션 처리)
  Future<Map<String, dynamic>> getList({int page = 0}) async {
    // 1. 데이터 준비 - 생략
    Response response =
        await dio.get("/api/post", queryParameters: {"page": page});
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // 조회 - 단일 조회
  Future<Map<String, dynamic>> getOne(int postId) async {
    Response response = await dio.get("/api/post/${postId}");
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // 삭제
  Future<Map<String, dynamic>> deleteOne(int postId) async {
    Response response = await dio.delete("/api/post/${postId}");
    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // 수정
  Future<Map<String, dynamic>> updateOne(Post post) async {
    Response response = await dio.put("/api/post/${post.id}", data: {
      "title": post.title,
      "content": post.content,
    });

    final responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }
}

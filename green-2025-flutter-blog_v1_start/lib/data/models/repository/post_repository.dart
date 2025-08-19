import 'package:flutter/material.dart'; // main() 실행 시 추
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../_core/utils/my_http.dart';

class PostRepository {
  // 글 작성 요청
  Future<Map<String, dynamic>> write(
      String accessToken, String title, String content) async {
    final requestBody = {
      "title": title,
      "content": content,
    };

    Response response = await dio.post(
      "/api/post",
      data: requestBody,
      options: Options(
        headers: {"Authorization": accessToken},
      ),
    );
    Map<String, dynamic> responseBody = response.data;
    Logger().e(responseBody);

    return responseBody;
  }

  // 목록 조회 (페이지 네이션 처리)
  Future<Map<String, dynamic>> list(String accessToken) async {
    Response response = await dio.get(
      "/api/post?page=0",
      options: Options(
        headers: {"Authorization": accessToken},
      ),
    );
    Map<String, dynamic> responseBody = response.data;
    Logger().i(responseBody);
    return responseBody;
  }

  // 조회 - 단일 조회
  Future<Map<String, dynamic>> detail(String accessToken) async {
    Response response = await dio.get(
      "/api/post/1",
      options: Options(
        headers: {
          "Authorization": accessToken,
        },
      ),
    );
    Map<String, dynamic> responseBody = response.data;
    Logger().i(responseBody);
    return responseBody;
  }

  // 삭제
  Future<Map<String, dynamic>> delete(String accessToken) async {
    Response response = await dio.delete(
      "/api/post/1",
      options: Options(
        headers: {"Authorization": accessToken},
      ),
    );
    Map<String, dynamic> responseBody = response.data;
    Logger().d(responseBody);
    return responseBody;
  }

  // 수정
  Future<Map<String, dynamic>> update(
      String title, String content, String accessToken) async {
    final requestBody = {
      "title": title,
      "content": content,
    };

    Response response = await dio.put(
      "/api/post/24",
      data: requestBody,
      options: Options(
        headers: {"Authorization": accessToken},
      ),
    );
    Map<String, dynamic> responseBody = response.data;
    Logger().e(responseBody);
    return responseBody;
  }
}

void main() {
  // PostRepository().write("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpbWdVcmwiOiIvaW1hZ2VzLzEucG5nIiwic3ViIjoibWV0YWNvZGluZyIsImlkIjoxLCJleHAiOjE3NTU3NTY3MTMsInVzZXJuYW1lIjoic3NhciJ9.6C8hiAyIiwwW9qUH4qBG8dmi_7aqepPVKmv9PGYh2qHTDItr4jbv064xrdV4_LpLiHShTgOsbLhH8abAFYS-sA","title 24", "content 24");
  //  PostRepository().list("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpbWdVcmwiOiIvaW1hZ2VzLzEucG5nIiwic3ViIjoibWV0YWNvZGluZyIsImlkIjoxLCJleHAiOjE3NTU3NTY3MTMsInVzZXJuYW1lIjoic3NhciJ9.6C8hiAyIiwwW9qUH4qBG8dmi_7aqepPVKmv9PGYh2qHTDItr4jbv064xrdV4_LpLiHShTgOsbLhH8abAFYS-sA");
  // PostRepository().detail("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpbWdVcmwiOiIvaW1hZ2VzLzEucG5nIiwic3ViIjoibWV0YWNvZGluZyIsImlkIjoxLCJleHAiOjE3NTU3NTY3MTMsInVzZXJuYW1lIjoic3NhciJ9.6C8hiAyIiwwW9qUH4qBG8dmi_7aqepPVKmv9PGYh2qHTDItr4jbv064xrdV4_LpLiHShTgOsbLhH8abAFYS-sA");
  // PostRepository().delete("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpbWdVcmwiOiIvaW1hZ2VzLzEucG5nIiwic3ViIjoibWV0YWNvZGluZyIsImlkIjoxLCJleHAiOjE3NTU3NTY3MTMsInVzZXJuYW1lIjoic3NhciJ9.6C8hiAyIiwwW9qUH4qBG8dmi_7aqepPVKmv9PGYh2qHTDItr4jbv064xrdV4_LpLiHShTgOsbLhH8abAFYS-sA");
  PostRepository().update("title 100", "content 100",
      "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpbWdVcmwiOiIvaW1hZ2VzLzEucG5nIiwic3ViIjoibWV0YWNvZGluZyIsImlkIjoxLCJleHAiOjE3NTU3NTY3MTMsInVzZXJuYW1lIjoic3NhciJ9.6C8hiAyIiwwW9qUH4qBG8dmi_7aqepPVKmv9PGYh2qHTDItr4jbv064xrdV4_LpLiHShTgOsbLhH8abAFYS-sA");
}

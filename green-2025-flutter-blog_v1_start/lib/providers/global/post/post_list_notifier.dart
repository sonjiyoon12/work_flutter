// 1. 게시글 목록에 대한 데이터를 설계 하자.
import 'package:flutter_blog/_core/utils/exception_handler.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:flutter_blog/data/models/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListModel {
  bool isFirst;
  bool isLast;
  int pageNumber; // 현재 페이지 번호 - 0번 부터 시작
  int size; // 페이지 당 게시글 갯수
  int totalPage; // 전체 페이지 수
  List<Post> posts; // 실제 게시글 데이터

  PostListModel(
    this.isFirst,
    this.isLast,
    this.pageNumber,
    this.size,
    this.totalPage,
    this.posts,
  );

  // 서버 응답 데이터를 PostListModel 객체로 변환 하는 생성자.
  // 네임드 생성자 호출 시 멤버 변수에 값을 할당 하려면 초기화 키워드 사용해야 한다.
  PostListModel.fromMap(Map<String, dynamic> data)
      : isFirst = data['isFirst'],
        isLast = data['isLast'],
        pageNumber = data['pageNumber'],
        size = data['size'],
        totalPage = data['totalPage'],
        posts = (data['posts'] as List).map((e) => Post.fromMap(e)).toList();
  // List<Post> --> Post(),Post(),Post()

  PostListModel copyWith({
    bool? isFirst,
    bool? isLast,
    int? pageNumber,
    int? size,
    int? totalPage,
    List<Post>? posts,
  }) {
    return PostListModel(
      isFirst ?? this.isFirst,
      isLast ?? this.isLast,
      pageNumber ?? this.pageNumber,
      size ?? this.size,
      totalPage ?? this.totalPage,
      posts ?? this.posts,
    );
  }

  @override
  String toString() {
    return 'PostListModel{isFirst: $isFirst, isLast: $isLast, pageNumber: $pageNumber, size: $size, totalPage: $totalPage, posts: $posts}';
  }
} // end if PostListModel class

class PostListNotifier extends Notifier<PostListModel?> {
  @override
  PostListModel? build() {
    // 창고 데이터 초기 모델은 항상 --> 통신 요청 이후에 결정이 된다
    // TODO 초기화 메서드 추가하기(통신요청)
    fetchPosts();
    return null;
  }

  // 1. fetchPosts - 게시글 목록 가져 오는 로직
  Future<Map<String, dynamic>> fetchPosts({int page = 0}) async {
    // TODO 예외 처리 추후 추가
    Map<String, dynamic> body = await PostRepository().getList(page: page);
    if (body["success"]) {
      // 서버에서 정상적으로 데이터를 내려 준다면 json 데이터를 PostListModel 로 파싱 처리
      PostListModel newModel = PostListModel.fromMap(body["response"]);
      // 상태 변경
      state = newModel;
      return {"success": true};
    } else {
      // 서버에서 내려준 에러 메세지를 사용자에게 보여 주자.
      ExceptionHandler.handleException(
          body["errorMessage"], StackTrace.current);
      return {"success": false};
    }
  }

  // 2. refreshPostList - 목록 새로 고침 로직

  // 3. loadMorePosts - 페이지 처리, 추가 데이터 요청
  Future<Map<String, dynamic>> loadMorePosts({int page = 0}) async {
    // 현재 페이지 불러오기
    print("현재 페이지 번호 : ${state!.pageNumber}");
    print("다음 페이지 번호 : ${state!.pageNumber + 1}");
    int nextPage = state!.pageNumber + 1;

    Map<String, dynamic> body = await PostRepository().getList(page: nextPage);
    if (body["success"]) {
      PostListModel newPostListModel = PostListModel.fromMap(body["response"]);
      List<Post> combinationPost = [...state!.posts, ...newPostListModel.posts];
      state = newPostListModel.copyWith(posts: combinationPost);
      return {"success": true};
    } else {
      return {"success": false};
    }
  }
}

final postListProvider = NotifierProvider<PostListNotifier, PostListModel?>(
    () => PostListNotifier());

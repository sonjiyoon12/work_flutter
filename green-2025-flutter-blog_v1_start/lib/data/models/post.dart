import 'package:flutter_blog/data/models/user.dart';

class Post {
  int id; // 게시물 ID
  String title;
  String content;
  DateTime createdAt; // 생성 일시
  DateTime updatedAt; // 수정 일시
  User user; // 작성자 (관계형 데이터)
  int bookmarkCount; // 북마크 수

  //현재 사용자의 북마크 여부(로그인 상태에 따라 달라짐)
  bool? isBookmark;

  // post.createdAt.year - 2025
  // post.createdAt.month - 5
  // DateTime.now().difference(post.createdAt); 현재 시간에서 생성 시간 빼기

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.bookmarkCount,
    this.isBookmark,
  });

  // User.fromMap(..)
  // 문자열을 DateTime 형변환 처리 해주어야 한다.
  Post.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        content = data['content'],
        createdAt = DateTime.parse(data['createdAt']),
        updatedAt = DateTime.parse(data['updatedAt']),
        isBookmark = data['isBookmark'],
        user = User.fromMap(data['user']),
        bookmarkCount = data['bookmarkCount'];

  Post copyWith({
    int? id,
    String? title,
    String? content,
    User? user,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? bookmarkCount,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bookmarkCount: bookmarkCount ?? this.bookmarkCount,
    );
  }

  // 디버깅용
  @override
  String toString() {
    return 'Post{id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, bookmarkCount: $bookmarkCount, isBookmark: $isBookmark}';
  }
}

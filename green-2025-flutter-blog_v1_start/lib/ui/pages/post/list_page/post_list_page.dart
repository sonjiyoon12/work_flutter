import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_body.dart';
import 'package:flutter_blog/ui/widgets/custom_navigator.dart';

class PostListPage extends StatelessWidget {
  // 보통 하위 위젯에게 키를 전달해 준다.
  // scaffoldKey 여기 프로젝트에서 drawer 위젯을 조절할 수 있다 (코드 상으로)
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // RefreshIndicator 관련 키
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomNavigation(scaffoldKey),
      appBar: AppBar(
        title: const Text("Blog"),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {},
        child: PostListBody(),
      ),
    );
  }
}

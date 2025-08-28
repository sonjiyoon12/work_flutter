import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/update_page/widgets/post_update_form.dart';

class PostUpdateBody extends StatelessWidget {
  final post;
  const PostUpdateBody(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PostUpdateForm(post),
    );
  }
}

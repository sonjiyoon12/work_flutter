import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/models/post.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostDetailProfile extends StatelessWidget {
  final Post post;

  const PostDetailProfile(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(post.user.username ?? ""),
        // child: Image.network('${baseUrl}${post.user.imgUrl}'),
        // http://192.168.0.187:8080/images/1.png
        leading: ClipOval(
          child: CachedNetworkImage(
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            imageUrl: "${baseUrl}${post.user.imgUrl}",
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        subtitle: Wrap(
          children: [
            const SizedBox(width: mediumGap),
            const Text("·"),
            const SizedBox(width: mediumGap),
            const Text("Written on "),
            Text("${post.createdAt}"),
          ],
        ));
  }
}

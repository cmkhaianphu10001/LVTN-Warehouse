import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/comment.dart';
import 'package:warehouse/colors.dart';
import 'package:http/http.dart' as http;

class CommentService {
  var url = domain + 'api/comment/';

  addComment(Comment comment) async {
    log(jsonEncode(comment).toString());
    SharedPreferences pre = await SharedPreferences.getInstance();

    try {
      var res = await http.post(Uri.parse(url + 'addComment'),
          headers: {
            "content-type": "application/json",
            "authorization": pre.getString('token'),
          },
          body: jsonEncode(comment));
      return res;
    } catch (e) {
      log(e.toString());
    }
  }

  getCommentsOfProduct(String productID) async {
    log('getCommentOfProduct');
    SharedPreferences pre = await SharedPreferences.getInstance();
    try {
      var res = await http.get(
        Uri.parse(url + 'getCommentsOfProduct'),
        headers: {
          "content-type": "application/json",
          "authorization": pre.getString('token'),
          "productid": productID,
        },
      );
      List<Comment> comments = (jsonDecode(res.body) as List)
          .map((e) => Comment.fromJson(e))
          .toList();
      comments = List.from(comments.reversed);
      return comments;
    } catch (e) {
      log(e.toString());
    }
  }
}

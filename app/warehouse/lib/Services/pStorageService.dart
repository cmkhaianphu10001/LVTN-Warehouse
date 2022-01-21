import 'dart:convert';
import 'dart:developer';

import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/colors.dart';
import 'package:http/http.dart' as http;

class PositionStorageService {
  var url = domain + 'api/user/';

  fnc(String token) async {
    var postUri = Uri.parse(url + 'getSupplier');
    try {
      var res = await http.get(
        postUri,
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
      );
      List<User> suppliers =
          (jsonDecode(res.body) as List).map((e) => User.fromJson(e)).toList();
      return suppliers;
    } catch (e) {
      log(e);
    }
  }
}

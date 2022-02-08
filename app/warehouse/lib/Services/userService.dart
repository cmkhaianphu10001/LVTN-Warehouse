import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/colors.dart';

class UserService {
  var url = domain + 'api/user/';

  getSupplier(String token) async {
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

  getManager(String token) async {
    var postUri = Uri.parse(url + 'getmanager');
    try {
      var res = await http.get(
        postUri,
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
      );
      List<User> manager =
          (jsonDecode(res.body) as List).map((e) => User.fromJson(e)).toList();
      return manager;
    } catch (e) {
      log(e);
    }
  }

  getUser(String token) async {
    var postUri = Uri.parse(url + 'getusers');
    try {
      var res = await http.get(
        postUri,
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
      );
      List<User> users =
          (jsonDecode(res.body) as List).map((e) => User.fromJson(e)).toList();
      return users;
    } catch (e) {
      log(e);
    }
  }
}

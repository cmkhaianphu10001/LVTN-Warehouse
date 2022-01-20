import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/colors.dart';

class AuthService {
  // Dio dio = new Dio();
  // var url = 'http://192.168.43.249:4000/api/user/';
  var url = domain + 'api/user/';
  register(User newUser) async {
    print(newUser.toJson());
    var bodyf = jsonEncode(newUser.toJson());
    try {
      var res = await http.post(
        Uri.parse(url + 'register'),
        body: bodyf,
        headers: {"content-type": "application/json"},
      );
      print(res.statusCode);
      return res;
    } catch (e) {
      print(e);
    }
  }

  otpVerify({String phone, String smsCode}) async {
    print(phone + "\n" + smsCode);
    var bodyf = jsonEncode({
      'phone': phone,
      'otp': smsCode,
    });
    try {
      var res = await http.post(
        Uri.parse(url + 'register/otpVerify'),
        body: bodyf,
        headers: {"content-type": 'application/json'},
      );
      print(res.statusCode);
      return res;
    } catch (e) {
      print(e);
    }
  }

  sendOtpCodeAgain(String phone) async {
    print(phone);
    var bodyf = jsonEncode({'phone': phone});
    try {
      var res = await http.post(
        Uri.parse(url + 'register/sendOtpCodeAgain'),
        body: bodyf,
        headers: {"content-type": 'application/json'},
      );
      print(res.statusCode);
      return res;
    } catch (e) {
      print(e);
    }
  }

  login({String email, String password}) async {
    print('email: $email \npassword: $password');
    var bodyf = jsonEncode({'email': email, 'password': password});
    try {
      var res = await http.post(
        Uri.parse(url + 'login'),
        body: bodyf,
        headers: {'content-type': 'application/json'},
      );
      print(res.statusCode);
      print(res.body);
      return res;
    } catch (e) {
      print(e);
    }
  }

  getUncheckUSer(String token) async {
    print('getUncheckUser');
    try {
      var res = await http.get(
        Uri.parse(url + 'register/getUncheckUser'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
      );
      List<User> listUncheckUser =
          (jsonDecode(res.body) as List).map((e) => User.fromJson(e)).toList();
      return listUncheckUser;
    } catch (e) {
      log(e);
    }
  }

  confirmAccount(String token, String targetEmail, bool action) async {
    print('confirming...');
    try {
      var res = await http.post(Uri.parse(url + 'register/confirmNewAccount'),
          headers: {
            "content-type": "application/json",
            "authorization": token,
          },
          body: jsonEncode({
            'targetEmail': targetEmail,
            'action': action,
          }));
      return res;
    } catch (e) {
      log(e);
    }
  }
}

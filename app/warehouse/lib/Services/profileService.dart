import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/helper/actionToFile.dart';
import 'package:warehouse/helper/uploadImage.dart';

class ProfileServices {
  Dio dio = new Dio();
  // var url = 'http://192.168.43.249:4000/api/profile/';
  var url = domain + 'api/profile/';

  getProfile(String token) async {
    print(token);
    // var bodyf = jsonEncode(newUser.toJson());
    try {
      var res = await http.get(
        Uri.parse(url + 'getProfile'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
      );
      var user = User.fromJson(jsonDecode(res.body));
      return user;
    } catch (e) {
      print(e);
    }
  }

  getUserById(String token, String _id) async {
    print('getUserByID');
    // var bodyf = jsonEncode(newUser.toJson());
    try {
      print('User : ' + _id);
      var res = await http.get(
        Uri.parse(url + 'getProfile'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
          "_id": _id,
        },
      );

      var user = User.fromJson(jsonDecode(res.body));
      return user;
    } catch (e) {
      print(e);
    }
  }

  // changeAvatar(String token, File imagePicked) async {
  //   var postUri = Uri.parse(url + 'changeAvatar');
  //   print(imagePicked);

  //   try {
  //     http.MultipartRequest request =
  //         new http.MultipartRequest("POST", postUri);

  //     http.MultipartFile multipartFile =
  //         await http.MultipartFile.fromPath('image', imagePicked.path);

  //     request.files.add(multipartFile);
  //     request.headers.addAll({
  //       "content-type": "multipart/form-data",
  //       "authorization": token,
  //     });

  //     var res = await request.send();

  //     print(res.stream.toString());
  //     return res;
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  changeAvatar(String token, User profile, File imagePicked) async {
    var postUri = Uri.parse(url + 'changeAvatar');
    print(imagePicked);

    try {
      String uri = await Storage().uploadImage(imagePicked, '/profile_images/');
      log(uri);

      if (uri != null) {
        var res = await http.post(
          postUri,
          headers: {
            "content-type": "application/json",
            "authorization": token,
          },
          body: jsonEncode({
            'image': uri,
          }),
        );
        log('set image successful');
        if (profile.image != null) {
          await Storage().deleteImage(getFullpathFromDB(profile.image));
        }

        return res;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/profileService.dart';
import 'package:warehouse/View/Profile/ProfleScreen.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/myInputAvatar.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:image_picker/image_picker.dart';

class ChangeAvatar extends StatefulWidget {
  const ChangeAvatar({Key key, this.profile}) : super(key: key);
  final User profile;
  @override
  _ChangeAvatarState createState() => _ChangeAvatarState(profile);
}

class _ChangeAvatarState extends State<ChangeAvatar> {
  final User profile;
  File _imagePicked;

  _ChangeAvatarState(this.profile);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(colors: [
                    my_org,
                    my_org_30,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          // color: my_org,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.keyboard_backspace,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Text(
                        'CHANGE AVATAR',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: my_org_30,
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(
                          Icons.person_outline_outlined,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MyInputAvatar(
                      height: size.height * 0.3,
                      width: size.height * 0.3,
                      imagePicked: _imagePicked,
                      getImageFromGallery: () async {
                        File image = File((await ImagePicker()
                                .pickImage(source: ImageSource.gallery))
                            .path);
                        setState(
                          () {
                            _imagePicked = image;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(),
                        ShortButton(
                          onclick: () async {
                            // print(_imagePicked.path);
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            var res = await ProfileServices().changeAvatar(
                                preferences.getString('token'),
                                profile,
                                _imagePicked);

                            if (res != null) {
                              if (res.statusCode == 200) {
                                // print(res.message);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen()),
                                    (route) => false);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'upload to firebase storage failed!',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                  textColor: Colors.black,
                                  fontSize: 16.0);
                            }
                          },
                          text: 'Submit',
                          toastText: 'Please wait...',
                        ),
                        ShortButton(
                          onclick: () {
                            Navigator.pop(context);
                          },
                          text: 'Cancel',
                        ),
                        SizedBox(),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

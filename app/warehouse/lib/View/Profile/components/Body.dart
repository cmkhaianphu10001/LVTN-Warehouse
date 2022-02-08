import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/profileService.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:warehouse/helper/actionToFile.dart';
import 'package:warehouse/wrapper.dart';

import '../ChangeAvatar.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String token;
  User profile;
  Future getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var res =
        await ProfileServices().getProfile(preferences.getString('token'));
    // print(res.body);
    token = preferences.getString('token');

    return profile = res;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: getProfile(),
      builder: (context, snap) {
        if (profile == null) {
          return MyLoading();
        } else {
          return Container(
            width: size.width,
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
                      gradient: LinearGradient(
                          colors: [
                            my_org,
                            my_org_30,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Wrapper()));
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
                            'PROFILE',
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
                  flex: 5,
                  child: Container(
                    width: size.width,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: size.height * 0.32,
                          left: size.width * 0.07,
                          child: GestureDetector(
                            onTap: () async {
                              log('message');
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Color(0xfff3f2f2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(Icons.edit_outlined),
                            ),
                          ),
                        ),
                        Positioned(
                          top: size.height * 0.32,
                          left: size.width * 0.1 + 80,
                          child: GestureDetector(
                            onTap: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              preferences.remove('token');
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Wrapper()),
                                  (route) => false);
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Color(0xfff3f2f2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(Icons.logout),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 30,
                          left: -50,
                          child: Container(
                            height: size.height * 0.25,
                            width: size.height * 0.35,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(100, 10, 10, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: size.height * 0.15,
                                    width: size.height * 0.15,
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          child: Container(
                                            height: size.height * 0.15,
                                            width: size.height * 0.15,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              backgroundImage: profile.image ==
                                                      ''
                                                  ? AssetImage(
                                                      'assets/images/default-person.png')
                                                  : NetworkImage(
                                                      getdownloadUriFromDB(
                                                          profile.image)),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: size.width * 0.1,
                                            width: size.width * 0.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.white60,
                                            ),
                                            child: IconButton(
                                              icon: Icon(Icons.camera_alt),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChangeAvatar(
                                                              profile: profile,
                                                            )));
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    profile.name,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    profile.email,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xfffffbd2),
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(300, 300))),
                          ),
                        ),
                        Positioned(
                          bottom: size.height * 0.35,
                          right: size.width * 0.05,
                          child: Container(
                            alignment: Alignment.center,
                            height: 100,
                            width: 170,
                            child: Text(
                              profile.phone,
                              style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xffffe3c0),
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(200, 150))),
                          ),
                        ),
                        Positioned(
                          bottom: size.height * 0.28,
                          right: size.width * 0.5,
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 130,
                            child: Text(
                              profile.role.toUpperCase(),
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xffffe3c0),
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(130, 60))),
                          ),
                        ),
                        Positioned(
                          bottom: size.height * 0.18,
                          left: size.width * 0.06,
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Color(0xffffe3c0),
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(80, 40))),
                          ),
                        ),
                        Positioned(
                          bottom: -70,
                          right: -110,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(60, 70, 130, 50),
                            height: 300,
                            width: size.width,
                            child: Text(
                              profile.address,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xfffffbd2),
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(300, 200))),
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          left: 25,
                          child: ShortButton(
                            text: 'BACK',
                            onclick: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Wrapper()),
                                  (route) => false);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

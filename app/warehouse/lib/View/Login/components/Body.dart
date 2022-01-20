import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Services/authService.dart';
import 'package:warehouse/View/Register/Register.dart';
import 'package:warehouse/components/LongButton.dart';
import 'package:warehouse/components/inkwell_link.dart';
import 'package:warehouse/components/myInputText.dart';
import 'package:warehouse/helper/validation.dart';
import 'package:warehouse/wrapper.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _key = GlobalKey<FormState>();

  String email, password;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, size.width * 0.1, 0),
                    alignment: Alignment.center,
                    height: size.height * 0.5,
                    width: size.width,
                    child: Image.asset(
                      "assets/images/logo_W.png",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    "assets/images/NamePro.png",
                    scale: 1,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      MyInputText(
                        controller: TextEditingController(text: email),
                        label: "Email",
                        onChanged: (val) {
                          email = val;
                        },
                        validator: (val) {
                          return Validation.validateEmail(val);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyInputText(
                        controller: TextEditingController(text: password),
                        obscureText: true,
                        label: "Password",
                        onChanged: (val) {
                          password = val;
                        },
                        validator: (val) {
                          return Validation.validatePass(val);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      LongButton(
                        text: "LOGIN",
                        toastText: "please wait",
                        onclick: () async {
                          if (_key.currentState.validate()) {
                            var res = await AuthService()
                                .login(email: email, password: password);

                            if (res.statusCode == 200) {
                              var rs = jsonDecode(res.body);
                              if (rs['success']) {
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                preferences.setString('token', rs['token']);
                                Fluttertoast.showToast(
                                    msg: 'Login successfully!',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.3),
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Wrapper()),
                                    (route) => false);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: res.body,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                  textColor: Colors.black,
                                  fontSize: 16.0);
                            }
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWellLink(
                        tag: "You don't have account?",
                        text: "Request account",
                        onclick: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/authService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConfirmAccountScreen extends StatelessWidget {
  final User user;
  const ConfirmAccountScreen({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Header(),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                  height: size.height * 5 / 6,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              'Request Account List',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 24,
                                  color: my_org,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        width: size.width,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: size.height * 0.55,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300],
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              )
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  height: size.height * 0.25,
                                  width: size.height * 0.23,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        "${user.name}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "${user.email}",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "${user.phone}",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  height: size.height * 0.2,
                                  width: size.height * 0.12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        "${user.role}",
                                        style: TextStyle(),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text("isVerified:"),
                                          Text('${user.verify}'),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: size.height * 0.15,
                              width: size.height * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text("${user.address}"),
                                  Text("${user.description}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ShortButton(
                            height: size.height * 0.06,
                            width: size.height * 0.12,
                            onclick: () async {
                              SharedPreferences pre =
                                  await SharedPreferences.getInstance();
                              var res = await AuthService().confirmAccount(
                                  pre.getString('token'), user.email, true);
                              if (res.statusCode == 200) {
                                Fluttertoast.showToast(
                                    msg: res.body,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.3),
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                                Navigator.pop(context, true);
                              } else {
                                Fluttertoast.showToast(
                                    msg: res.body,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.3),
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                              }
                            },
                            text: 'Accept',
                            toastText: 'Please Wait...',
                          ),
                          ShortButton(
                            height: size.height * 0.06,
                            width: size.height * 0.12,
                            onclick: () async {
                              SharedPreferences pre =
                                  await SharedPreferences.getInstance();
                              var res = await AuthService().confirmAccount(
                                  pre.getString('token'), user.email, false);
                              if (res.statusCode == 200) {
                                Fluttertoast.showToast(
                                    msg: res.body,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.3),
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                                Navigator.pop(context, true);
                              } else {
                                Fluttertoast.showToast(
                                    msg: res.body,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.3),
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                              }
                            },
                            text: 'Denie',
                            toastText: 'Please Wait...',
                          ),
                          ShortButton(
                            height: size.height * 0.06,
                            width: size.height * 0.12,
                            onclick: () {
                              Navigator.pop(context, true);
                            },
                            text: 'Cancel',
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

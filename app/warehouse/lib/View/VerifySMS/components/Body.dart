import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:warehouse/Services/authService.dart';
import 'package:warehouse/View/Login/Login.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/inkwell_link.dart';
import 'package:warehouse/components/myInputText.dart';
import 'package:warehouse/components/shortButton.dart';

class Body extends StatefulWidget {
  final String phone;
  const Body({Key key, this.phone}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(phone: phone);
}

class _BodyState extends State<Body> {
  final String phone;

  _BodyState({this.phone});
  @override
  Widget build(BuildContext context) {
    print(phone);
    Size size = MediaQuery.of(context).size;
    String smsCode;
    final _key = GlobalKey<FormState>();
    return SingleChildScrollView(
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            Background(size: size),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: size.height * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'SMS code sent to your phone number: ' + phone.toString(),
                    style: TextStyle(
                        // fontSize: 15,
                        ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyInputText(
                    controller: TextEditingController(text: smsCode),
                    label: 'smsCode',
                    onChanged: (val) {
                      smsCode = val;
                    },
                    validator: (String val) {
                      if (val != null) {
                        if (val.length != 6) {
                          return 'sms Code only 6 digits';
                        } else {
                          return null;
                        }
                      } else {
                        return 'Input sms Code to verify';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ShortButton(
                    onclick: () async {
                      if (_key.currentState.validate()) {
                        var res = await AuthService()
                            .otpVerify(phone: phone, smsCode: smsCode);
                        if (res.statusCode == 200) {
                          Fluttertoast.showToast(
                              msg: res.body,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey.withOpacity(0.3),
                              textColor: Colors.black,
                              fontSize: 16.0);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
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
                        print('not validated');
                      }
                    },
                    text: 'VERIFY',
                    toastText: 'Please wait...',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWellLink(
                    onclick: () async {
                      Fluttertoast.showToast(
                          msg: 'sending...',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          textColor: Colors.black,
                          fontSize: 16.0);
                      var res = await AuthService().sendOtpCodeAgain(phone);
                      Fluttertoast.showToast(
                          msg: res.body,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          textColor: Colors.black,
                          fontSize: 16.0);
                    },
                    tag: 'Resend sms code?',
                    text: 'Send',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      alignment: Alignment.center,
      height: size.height * 0.2,
      width: size.width,
      decoration: BoxDecoration(
        color: my_org,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
        ),
      ),
      child: Text(
        'Verify SMS code',
        style: TextStyle(
          color: Color(0xffe79532),
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

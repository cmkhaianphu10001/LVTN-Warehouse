import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/authService.dart';
import 'package:warehouse/View/Login/Login.dart';
import 'package:warehouse/View/VerifySMS/VerifySMS.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/LongButton.dart';
import 'package:warehouse/components/inkwell_link.dart';
import 'package:warehouse/components/myDropDownBtn.dart';

import 'package:warehouse/components/myInputText.dart';
import 'package:warehouse/components/myInputTextArea.dart';
import 'package:warehouse/components/myPhoneInput.dart';
import 'package:warehouse/helper/validation.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _key = GlobalKey<FormState>();

  User registerUser = User();

  String dropdownvalue;

  String temppass;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            Background(size: size),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 10,
            ),
            MyDropDownBtn(
              items: <String>[
                'manager',
                'customer',
                'supplier',
              ].map<DropdownMenuItem<String>>((String val) {
                // print(val);
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              }).toList(),
              label: "You are?",
              onChange: (String newval) {
                setState(() {
                  dropdownvalue = newval;
                  registerUser.role = newval;
                });
                print(registerUser.role);
              },
              value: dropdownvalue,
              validator: (val) {
                return Validation.checkDropDownValue(val);
              },
            ),
            SizedBox(
              height: 10,
            ),
            MyInputText(
              controller: TextEditingController(text: registerUser.name),
              onChanged: (val) {
                registerUser.name = val;
              },
              label: "Name",
              validator: (val) {
                return Validation.inputStringValidate(val);
              },
            ),
            SizedBox(
              height: 10,
            ),
            MyInputText(
              controller: TextEditingController(text: registerUser.email),
              onChanged: (val) {
                registerUser.email = val;
              },
              label: "Email",
              validator: (val) {
                return Validation.validateEmail(val);
              },
            ),
            SizedBox(
              height: 10,
            ),
            MyPhoneInput(
              controller: TextEditingController(text: registerUser.phone),
              label: 'Your phone number',
              onPhoneNumChange: (val) {
                registerUser.phone = val.phoneNumber;
              },
            ),
            SizedBox(
              height: 10,
            ),
            MyInputText(
              label: "Address",
              controller: TextEditingController(text: registerUser.address),
              onChanged: (val) {
                registerUser.address = val;
              },
              validator: (val) {
                return Validation.inputStringValidate(val);
              },
            ),
            SizedBox(
              height: 10,
            ),
            MyInputText(
              obscureText: true,
              label: "Password",
              controller: TextEditingController(text: registerUser.password),
              onChanged: (val) {
                registerUser.password = val;
              },
              validator: (val) {
                return Validation.validatePass(val);
              },
            ),
            SizedBox(
              height: 10,
            ),
            MyInputText(
              obscureText: true,
              label: "Cf_Password",
              onChanged: (val) {
                setState(() {
                  temppass = val;
                });
              },
              validator: (val) {
                return Validation.validateCfPass(
                    registerUser.password, temppass);
              },
            ),
            SizedBox(
              height: 10,
            ),
            MyInputTextArea(
              label: "Description",
              controller: TextEditingController(text: registerUser.description),
              onChanged: (val) {
                registerUser.description = val;
              },
              validator: (val) {
                return Validation.validatePass(val);
              },
            ),
            SizedBox(
              height: 50,
            ),
            LongButton(
              onclick: () async {
                if (_key.currentState.validate()) {
                  var res = await AuthService().register(registerUser);
                  if (res.statusCode == 200) {
                    Fluttertoast.showToast(
                      msg: res.body,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      textColor: Colors.black,
                      fontSize: 16.0,
                    );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VerifySMS(phone: registerUser.phone)));
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
                  print('wrong');
                }
              },
              text: "SUBMIT",
              toastText: 'Please wait',
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: InkWellLink(
                tag: "You have account?",
                text: "Login",
                onclick: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              ),
            ),
            SizedBox(
              height: 100,
            )
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
        'Request Account',
        style: TextStyle(
          color: Color(0xffe79532),
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

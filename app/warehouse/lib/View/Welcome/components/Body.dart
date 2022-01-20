import 'package:flutter/material.dart';
import 'package:warehouse/View/Login/Login.dart';
import 'package:warehouse/View/Register/Register.dart';
import 'package:warehouse/components/LongButton.dart';
import 'package:warehouse/components/inkwell_link.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: size.height * 0.6,
              width: size.width,
              child: Image.asset(
                "assets/images/background_01.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: 50,
            child: Image.asset(
              "assets/images/background_02.png",
              scale: 1,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 30,
            left: 40,
            right: 0,
            child: Image.asset(
              "assets/images/Logo_name.png",
              scale: 1,
            ),
          ),
          Positioned(
            top: 70,
            // bottom: 30,
            // left: 40,
            right: 30,
            child: Image.asset(
              "assets/images/Mask_group.png",
              scale: 1,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              height: size.height * 0.3,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  LongButton(
                    onclick: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    text: 'LOGIN',
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWellLink(
                    onclick: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    tag: "You don't have account?",
                    text: 'request account',
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

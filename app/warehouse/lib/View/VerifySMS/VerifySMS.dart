import 'package:flutter/material.dart';

import 'components/Body.dart';

class VerifySMS extends StatefulWidget {
  final String phone;
  VerifySMS({this.phone});
  @override
  _VerifySMSState createState() => _VerifySMSState(phone: phone);
}

class _VerifySMSState extends State<VerifySMS> {
  final String phone;

  _VerifySMSState({this.phone});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        phone: phone,
      ),
    );
  }
}

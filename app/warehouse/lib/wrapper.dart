import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/View/App_Customer/cusHome/CusHome.dart';
import 'package:warehouse/View/App_Manager/mngHome/MngHome.dart';
import 'package:warehouse/View/App_Supplier/supHome/SupHome.dart';
import 'package:warehouse/View/Welcome/Welcome.dart';

import 'components/loading_view.dart';
import 'helper/JWTconvert.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int load;
  String token;
  var payload;
  @override
  void initState() {
    getData().whenComplete(() async {
      if (token == null) {
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Welcome()),
            (route) => false);
      } else {
        payload = parseJwt(token);
        switch (payload['role']) {
          case 'customer':
            return Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => CusHome()),
                (route) => false);
          case 'supplier':
            return Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SupHome()),
                (route) => false);
          case 'manager':
            return Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MngHome()),
                (route) => false);
          default:
            print(payload['role'] + ': wrong roles');
            return Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Welcome()),
                (route) => false);
        }
      }
    });
    super.initState();
  }

  Future getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      load = 1;
    });
    return MyLoading();
  }
}

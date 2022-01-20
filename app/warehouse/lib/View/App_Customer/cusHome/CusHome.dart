import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/helper/JWTconvert.dart';

import 'components/Body.dart';

class CusHome extends StatefulWidget {
  const CusHome({Key key}) : super(key: key);

  @override
  _CusHomeState createState() => _CusHomeState();
}

class _CusHomeState extends State<CusHome> {
  var passport;
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      passport = parseJwt(preferences.getString('token'));
    });
    return passport;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Body(),
    );
  }
}

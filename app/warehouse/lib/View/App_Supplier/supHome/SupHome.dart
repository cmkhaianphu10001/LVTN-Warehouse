import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/helper/JWTconvert.dart';

import 'components/Body.dart';

class SupHome extends StatefulWidget {
  const SupHome({Key key}) : super(key: key);

  @override
  _SupHomeState createState() => _SupHomeState();
}

class _SupHomeState extends State<SupHome> {
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
    return Scaffold(
      body: Body(),
    );
  }
}

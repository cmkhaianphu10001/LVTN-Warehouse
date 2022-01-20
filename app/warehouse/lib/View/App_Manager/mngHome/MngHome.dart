import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/helper/JWTconvert.dart';
import './components/Body.dart';

class MngHome extends StatefulWidget {
  const MngHome({Key key}) : super(key: key);

  @override
  _MngHomeState createState() => _MngHomeState();
}

class _MngHomeState extends State<MngHome> {
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
      drawer: MyDrawer(),
      body: Body(),
    );
  }
}

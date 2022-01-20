import 'package:flutter/material.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';

import 'components/Body.dart';

class RequestAccountList extends StatelessWidget {
  const RequestAccountList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Body(),
    );
  }
}

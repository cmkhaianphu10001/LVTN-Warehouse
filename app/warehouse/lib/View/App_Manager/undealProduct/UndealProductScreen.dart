import 'package:flutter/material.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';

import 'components/body.dart';

class UndealProductScreen extends StatefulWidget {
  const UndealProductScreen({Key key}) : super(key: key);

  @override
  _UndealProductScreenState createState() => _UndealProductScreenState();
}

class _UndealProductScreenState extends State<UndealProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Body(),
    );
  }
}

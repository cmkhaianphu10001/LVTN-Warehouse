import 'package:flutter/material.dart';

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
      body: Body(),
    );
  }
}

import 'package:flutter/material.dart';

import 'components/Body.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({Key key}) : super(key: key);

  @override
  _AddNewProductScreenState createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

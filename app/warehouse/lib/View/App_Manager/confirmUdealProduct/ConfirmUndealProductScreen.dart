import 'package:flutter/material.dart';
import 'package:warehouse/Models/undealProductModel.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';

import 'components/Body.dart';

class ConfirmUndealProductScreen extends StatelessWidget {
  final UndealProduct undealProduct;
  const ConfirmUndealProductScreen({Key key, this.undealProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Body(
        undealProduct: undealProduct,
      ),
    );
  }
}

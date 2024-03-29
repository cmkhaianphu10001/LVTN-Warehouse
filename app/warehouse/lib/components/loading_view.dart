import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          SpinKitChasingDots(
            color: Color(0xfff85f6a),
            size: 50.0,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../colors.dart';

class ShortButton extends StatelessWidget {
  final double height, width;
  final String text;
  final String toastText;
  final Function onclick;
  const ShortButton({
    Key key,
    this.text,
    this.onclick,
    this.toastText,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        if (toastText != null) {
          Fluttertoast.showToast(
              msg: toastText,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey.withOpacity(0.3),
              textColor: Colors.black,
              fontSize: 16.0);
        }
      },
      onTap: () {
        onclick();
      },
      child: Container(
        height: height ?? 50,
        width: width ?? size.width * 0.35,
        child: Material(
          borderRadius: BorderRadius.circular(50),
          color: my_org,
          shadowColor: my_org,
          elevation: 7,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

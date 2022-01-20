import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../colors.dart';

class LongButton extends StatelessWidget {
  final String text;
  final String toastText;
  final Function onclick;
  const LongButton({
    Key key,
    this.text,
    this.onclick,
    this.toastText,
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
        height: 50,
        width: size.width * 0.8,
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

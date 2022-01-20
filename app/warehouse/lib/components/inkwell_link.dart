import 'package:flutter/material.dart';

class InkWellLink extends StatelessWidget {
  final String tag;
  final String text;
  final Function onclick;
  const InkWellLink({
    Key key,
    this.tag,
    this.text,
    this.onclick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          tag,
          style: TextStyle(
            color: Colors.black,
            fontSize: 13,
          ),
        ),
        InkWell(
          onTap: () {
            onclick();
          },
          child: Text(
            text,
            style: TextStyle(
                fontSize: 17,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}

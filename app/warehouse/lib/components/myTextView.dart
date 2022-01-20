import 'package:flutter/material.dart';

class MyTextView extends StatelessWidget {
  const MyTextView({
    Key key,
    this.label,
    @required this.content,
    this.width,
    this.height,
    this.textSize,
  }) : super(key: key);

  final String label;
  final double width, height;
  final String content;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label != null ? label : '',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 5,
          ),
          alignment: Alignment.centerLeft,
          height: height != null ? height : 70,
          width: width != null ? width : size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            content != null ? content : '',
            style: TextStyle(
              fontSize: textSize != null ? textSize : 20,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

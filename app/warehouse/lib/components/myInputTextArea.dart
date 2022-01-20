import 'package:flutter/material.dart';
import 'package:warehouse/colors.dart';

class MyInputTextArea extends StatelessWidget {
  final String label;
  final Function validator;
  final Function onChanged;
  final bool enabled;
  final String initialValue;
  final TextEditingController controller;
  const MyInputTextArea({
    Key key,
    this.label,
    this.validator,
    this.onChanged,
    this.enabled,
    this.initialValue,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 200,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 5,
            ),
            width: size.width * 0.8,
            decoration: BoxDecoration(
              // border: Border.all(color: myPrimary),
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: TextFormField(
              controller: controller,
              initialValue: initialValue,
              enabled: enabled,
              maxLines: 8,
              validator: validator,
              onChanged: onChanged,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: my_org),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

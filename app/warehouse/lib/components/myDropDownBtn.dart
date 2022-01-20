import 'package:flutter/material.dart';

class MyDropDownBtn extends StatelessWidget {
  const MyDropDownBtn({
    Key key,
    this.value,
    this.items,
    this.onChange,
    this.validator,
    this.hint = '',
    this.label = '',
  }) : super(key: key);

  final List<DropdownMenuItem<String>> items;
  final String hint;
  final String value;
  final Function onChange;
  final Function validator;
  final String label;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
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
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 5,
          ),
          height: 60,
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
          child: DropdownButtonFormField<String>(
              hint: Text(hint),
              value: value,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              validator: validator,
              onChanged: onChange,
              items: items),
        ),
      ],
    );
  }
}

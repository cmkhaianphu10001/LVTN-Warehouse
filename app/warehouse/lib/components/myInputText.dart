import 'package:flutter/material.dart';
import 'package:warehouse/colors.dart';

class MyInputText extends StatelessWidget {
  final double height, width;
  final String label;
  final Function validator;
  final Function onChanged;
  final bool obscureText;
  final Function suffixIconOnPressed;
  final TextInputType keytype;
  final String initialValue;
  final bool enabled;
  final TextEditingController controller;
  const MyInputText({
    Key key,
    this.label,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.suffixIconOnPressed,
    this.keytype,
    this.initialValue,
    this.enabled,
    this.controller,
    this.height,
    this.width,
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
            height: 60,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 5,
            ),
            width: width ?? size.width * 0.8,
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
              enabled: enabled,
              initialValue: initialValue,
              keyboardType: keytype,
              validator: validator,
              onChanged: onChanged,
              obscureText: obscureText ? true : false,
              decoration: InputDecoration(
                suffixIcon: suffixIconOnPressed == null
                    ? null
                    : IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: suffixIconOnPressed,
                      ),
                // hintText: label,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: my_org),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../colors.dart';

class MyPhoneInput extends StatelessWidget {
  final String label;
  final Function onPhoneNumChange;
  final TextEditingController controller;
  const MyPhoneInput({
    Key key,
    this.onPhoneNumChange,
    this.label,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            height: 80,
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
            child: InternationalPhoneNumberInput(
              initialValue: PhoneNumber(dialCode: '+84', isoCode: 'VN'),
              onInputChanged: onPhoneNumChange,
              onInputValidated: (bool value) {
                print(value);
              },
              textFieldController: controller,
              // errorMessage: 'Fill your phone number',
              autoValidateMode: AutovalidateMode.disabled,
              ignoreBlank: false,
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              inputDecoration: InputDecoration(
                  hintText: '0987456321',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: my_org))),
            ),
          ),
        ],
      ),
    );
  }
}

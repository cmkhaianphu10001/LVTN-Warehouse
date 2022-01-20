import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class MyPickDate extends StatelessWidget {
  const MyPickDate({
    Key key,
    @required this.dateVariable,
    this.onConfirm,
    this.onChanged,
  }) : super(key: key);

  final String dateVariable;
  // must be dateVariable = "20201214" if 2020-12-14
  final Function onConfirm, onChanged;
  // return DateTime("2020-12-14")

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Pick Date',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          // padding: EdgeInsets.zero,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(10),
          // ),
          // color: Colors.grey[200],
          child: Container(
            alignment: Alignment.centerLeft,
            height: 60,
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
            child: Text(
              dateVariable != null ? dateVariable : 'YYYY-MM-DD',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ),
          onTap: () {
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              minTime: DateTime(2018, 1, 5),
              maxTime: DateTime(2022, 12, 20),
              onChanged: onChanged,
              onConfirm: onConfirm,
              currentTime: DateTime.now(),
              locale: LocaleType.vi,
            );
          },
        ),
      ],
    );
  }
}

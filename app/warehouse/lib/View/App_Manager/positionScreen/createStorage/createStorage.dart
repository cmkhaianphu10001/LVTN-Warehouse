import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Services/positionService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/components/LongButton.dart';
import 'package:warehouse/components/myInputText.dart';
import 'package:warehouse/components/myInputTextArea.dart';
import 'package:warehouse/helper/validation.dart';

class CreateStorage extends StatefulWidget {
  const CreateStorage({Key key}) : super(key: key);

  @override
  _CreateStorageState createState() => _CreateStorageState();
}

class _CreateStorageState extends State<CreateStorage> {
  final _key = GlobalKey<FormState>();
  String positionName, description;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: MyDrawer(),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Header(
                title: 'Create Position',
                userDrawer: false,
                preLoad: true,
              ),
            ),
            Expanded(
              flex: 5,
              child: Form(
                key: _key,
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        MyInputText(
                          controller: TextEditingController(text: positionName),
                          label: 'positionName',
                          onChanged: (val) {
                            positionName = val;
                          },
                          validator: (val) {
                            return Validation.inputStringValidate(val);
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        MyInputTextArea(
                          controller: TextEditingController(text: description),
                          label: 'description',
                          onChanged: (val) {
                            description = val;
                          },
                          validator: (val) {
                            return Validation.inputStringValidate(val);
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.2,
                        ),
                        LongButton(
                          onclick: () async {
                            if (_key.currentState.validate()) {
                              SharedPreferences pre =
                                  await SharedPreferences.getInstance();
                              var res = await PositionService().createStorage(
                                  pre.getString('token'),
                                  positionName,
                                  description);

                              Fluttertoast.showToast(
                                  msg: res.body,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                  textColor: Colors.black,
                                  fontSize: 16.0);
                              if (res.statusCode == 200) {
                                Navigator.pop(context, true);
                              }
                            }
                          },
                          text: 'SUBMIT',
                          toastText: 'Please wait...',
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

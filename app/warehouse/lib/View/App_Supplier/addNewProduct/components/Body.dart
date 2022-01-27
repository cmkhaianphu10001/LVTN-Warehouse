import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/View/App_Supplier/Header.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/myInputImage.dart';
import 'package:warehouse/components/myInputText.dart';
import 'package:warehouse/components/myInputTextArea.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:warehouse/helper/validation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Product newProduct = new Product();
  final _key = GlobalKey<FormState>();
  File _imagePicked;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(flex: 1, child: Header()),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                  // height: size.height * 5 / 6,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: size.width,
                        child: Text(
                          'Add New Product',
                          style: TextStyle(
                              // decoration: TextDecoration.underline,
                              fontSize: 20,
                              color: my_org,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 1,
                        width: size.width,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputText(
                        controller:
                            TextEditingController(text: newProduct.productName),
                        label: 'Product Name',
                        onChanged: (val) {
                          newProduct.productName = val;
                        },
                        validator: (val) {
                          return Validation.inputStringValidate(val);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputText(
                        controller:
                            TextEditingController(text: newProduct.unit),
                        label: 'Unit',
                        onChanged: (val) {
                          newProduct.unit = val;
                        },
                        validator: (val) {
                          return Validation.inputStringValidate(val);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputText(
                        label: 'Price',
                        keytype: TextInputType.number,
                        onChanged: (val) {
                          setState(() {
                            newProduct.importPrice =
                                val != '' ? double.parse(val) : 0;
                          });
                        },
                        validator: (val) {
                          return Validation.inputIntValidate(val);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputTextArea(
                        controller:
                            TextEditingController(text: newProduct.description),
                        label: 'Description',
                        onChanged: (val) {
                          newProduct.description = val;
                        },
                        validator: (val) {
                          return Validation.inputStringValidate(val);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MyInputImage(
                              imagePicked: _imagePicked,
                              getImageFromGallery: () async {
                                File image = File((await ImagePicker()
                                        .pickImage(source: ImageSource.gallery))
                                    .path);
                                setState(
                                  () {
                                    _imagePicked = image;
                                  },
                                );
                              },
                            ),
                            Container(
                              height: size.height * 0.2,
                              // color: Colors.red,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ShortButton(
                                    onclick: () async {
                                      if (_key.currentState.validate()) {
                                        if (_imagePicked != null) {
                                          // print('ok');
                                          SharedPreferences preferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          var token =
                                              preferences.getString('token');
                                          var res = await ProductService()
                                              .addNewProduct(newProduct,
                                                  _imagePicked, token);

                                          if (res.statusCode == 200) {
                                            Fluttertoast.showToast(
                                                msg: res.body.toString(),
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.grey
                                                    .withOpacity(0.3),
                                                textColor: Colors.black,
                                                fontSize: 16.0);
                                            Navigator.pop(context, true);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: res.body.toString(),
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.grey
                                                    .withOpacity(0.3),
                                                textColor: Colors.black,
                                                fontSize: 16.0);
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Pleast input Image',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.3),
                                              textColor: Colors.black,
                                              fontSize: 16.0);
                                        }
                                      }
                                    },
                                    text: 'Submit',
                                  ),
                                  ShortButton(
                                    onclick: () {
                                      Navigator.pop(context, true);
                                    },
                                    text: 'Cancel',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

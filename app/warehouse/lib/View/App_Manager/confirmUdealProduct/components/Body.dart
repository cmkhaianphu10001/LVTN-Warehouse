import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/undealProductModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/Services/profileService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';

import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/components/myInputText.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:warehouse/helper/actionToFile.dart';

class Body extends StatefulWidget {
  final UndealProduct undealProduct;
  const Body({Key key, this.undealProduct}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(undealProduct);
}

class _BodyState extends State<Body> {
  final UndealProduct undealProduct;
  _BodyState(this.undealProduct);

  Future getData(String supID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return ProfileServices().getUserById(preferences.getString('token'), supID);
  }

  String newPrice, ratePrice;
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: getData(undealProduct.supID),
        builder: (context, snap) {
          if (!(snap.data != null)) {
            return MyLoading();
          } else {
            return Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Header(
                      userDrawer: false,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Form(
                      key: _key,
                      child: Container(
                        // padding: EdgeInsets.all(20),
                        // color: Colors.red,
                        child: Stack(
                          children: <Widget>[
                            //title
                            Positioned(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                width: size.width,
                                child: Text(
                                  'Confirm New Product',
                                  style: TextStyle(
                                      // decoration: TextDecoration.underline,
                                      fontSize: 20,
                                      color: my_org,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            //line
                            Positioned(
                              top: 25,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Container(
                                  height: 1,
                                  width: size.width - 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            //background
                            Positioned(
                              // top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Image.asset(
                                "assets/images/bgProduct.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            // price and input
                            Positioned(
                              right: size.width * 0.05,
                              top: size.height * 0.25,
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "current Price: \$${undealProduct.importPrice}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    MyInputText(
                                      keytype: TextInputType.number,
                                      controller:
                                          TextEditingController(text: newPrice),
                                      width: size.width * 0.2,
                                      onChanged: (val) {
                                        newPrice = val != '' ? val : null;
                                      },
                                      validator: (val) {
                                        return null;
                                      },
                                      label: 'New Price?',
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Rate Price: ${undealProduct.ratePrice}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    MyInputText(
                                      keytype: TextInputType.number,
                                      controller: TextEditingController(
                                          text: ratePrice),
                                      width: size.width * 0.2,
                                      onChanged: (val) {
                                        ratePrice = val != '' ? val : null;
                                      },
                                      validator: (val) {
                                        return null;
                                      },
                                      label: 'change?',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //image
                            Positioned(
                              top: size.height * 0.07,
                              left: size.width * 0.05,
                              child: Container(
                                height: size.height * 0.25,
                                width: size.height * 0.22,
                                decoration: BoxDecoration(
                                  // border: Border.all(color: my_org),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: Offset(
                                          0, 7), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Image.network(
                                  getdownloadUriFromDB(
                                    undealProduct.image,
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            //Name unit supplier name
                            Positioned(
                              top: size.height * 0.35,
                              left: size.width * 0.15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${undealProduct.productName}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    "${undealProduct.unit}",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    "${snap.data.name}",
                                    style: TextStyle(
                                      // fontStyle: FontStyle.italic,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
//decripsion
                            Positioned(
                              top: size.height * 0.55,
                              left: size.width * 0.1,
                              child: Container(
                                // height: size.height * 0.3,
                                width: size.width * 0.7,
                                child: Text("${undealProduct.description}"),
                              ),
                            ),
//Btn
                            Positioned(
                              top: size.height * 0.73,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                    size.width * 0.05, 0, size.width * 0.05, 0),
                                width: size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ShortButton(
                                      height: 40,
                                      width: size.width * 0.25,
                                      onclick: () async {
                                        SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();

                                        var res = await ProductService()
                                            .confirmUndealProduct(
                                                preferences.getString('token'),
                                                undealProduct.id,
                                                true,
                                                ratePrice: ratePrice != null
                                                    ? double.parse(ratePrice)
                                                    : null,
                                                newPrice: newPrice != null
                                                    ? double.parse(newPrice)
                                                    : null);
                                        log(res.statusCode.toString());
                                        if (res.statusCode == 200) {
                                          Fluttertoast.showToast(
                                              msg: res.body.toString(),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.3),
                                              textColor: Colors.black,
                                              fontSize: 16.0);
                                          Navigator.pop(context, true);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: res.body.toString(),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.3),
                                              textColor: Colors.black,
                                              fontSize: 16.0);
                                        }
                                      },
                                      text: 'Accept',
                                    ),
                                    ShortButton(
                                      height: 40,
                                      width: size.width * 0.25,
                                      onclick: () async {
                                        SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();

                                        var res = await ProductService()
                                            .confirmUndealProduct(
                                                preferences.getString('token'),
                                                undealProduct.id,
                                                false);

                                        if (res.statusCode == 200) {
                                          Fluttertoast.showToast(
                                              msg: res.body.toString(),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.3),
                                              textColor: Colors.black,
                                              fontSize: 16.0);
                                          Navigator.pop(context, true);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: res.body.toString(),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.3),
                                              textColor: Colors.black,
                                              fontSize: 16.0);
                                        }
                                      },
                                      text: 'Denie',
                                    ),
                                    ShortButton(
                                      height: 40,
                                      width: size.width * 0.25,
                                      onclick: () {
                                        Navigator.pop(context, false);
                                      },
                                      text: 'Cancel',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}

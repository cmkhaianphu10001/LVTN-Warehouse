import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/cart.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/Services/userService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';

import 'package:warehouse/View/App_Manager/importScreen/productOfSupplierSreen/ProductsOfSupplier.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/components/myDialog.dart';
import 'package:warehouse/components/myDropDownBtn.dart';
import 'package:warehouse/components/myPickDate.dart';
import 'package:warehouse/components/myTextView.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:warehouse/helper/actionToFile.dart';
import 'package:warehouse/helper/validation.dart';

import 'editProductImport/EditProductImport.dart';
import 'importResult/importResultScreen.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({Key key}) : super(key: key);

  @override
  _ImportScreenState createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  Future getSupplier() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var token = pre.getString('token');
    List<User> res = await UserService().getSupplier(token);
    return res;
  }

  User supplierPicked;
  String supplierPickedId;
  DateTime datePicked;

  @override
  void initState() {
    datePicked = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      drawer: MyDrawer(),
      body: FutureBuilder(
        future: getSupplier(),
        builder: (context, snap) {
          if (!(snap.data != null)) {
            return MyLoading();
          } else {
            List<User> suppliers = snap.data;
            // log('${suppliers}');
            return Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Header(
                        title: 'IMPORT',
                      )),
                  Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: size.width,
                              child: Text(
                                'Import Product!',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 24,
                                    color: my_org,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            //listview
                            Container(
                                height: 1,
                                width: size.width,
                                color: Colors.grey),

                            SizedBox(
                              height: 20,
                            ),

                            MyDropDownBtn(
                              value: supplierPickedId,
                              hint: 'Choose supplier..',
                              label: 'Supplier',
                              onChange: (String newValue) {
                                setState(() {
                                  supplierPickedId = newValue;
                                  supplierPicked = suppliers.firstWhere(
                                      (element) => element.id == newValue);
                                  cart.clear();
                                });
                              },
                              validator: (value) {
                                return Validation.checkDropDownValue(value);
                              },
                              items: suppliers.map<DropdownMenuItem<String>>(
                                  (User supplier) {
                                return DropdownMenuItem<String>(
                                  value: supplier.id,
                                  child: Text(supplier.name),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyPickDate(
                              dateVariable:
                                  "${datePicked.day}-${datePicked.month}-${datePicked.year}",
                              onConfirm: (value) {
                                setState(() {
                                  datePicked = value;
                                });
                                print('date - $datePicked');
                              },
                              onChanged: (value) {
                                print('change $value');
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Stack(children: <Widget>[
                              Container(
                                alignment: Alignment.topCenter,
                                height: size.height * 0.3,
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: my_org),
                                  color: Colors.grey[200],
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.all(10),
                                  itemCount: cart.itemCount,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: <Widget>[
                                        Container(
                                          child: GestureDetector(
                                            onTap: () async {
                                              // to product

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProductImport(
                                                    supplier: supplierPicked,
                                                    cartItem:
                                                        cart.listItem[index],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.only(left: 5),
                                              alignment: Alignment.center,
                                              height: 70,
                                              width: size.width * 0.8,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      height: size.width * 0.1,
                                                      width: size.width * 0.1,
                                                      // color: Colors.blueAccent,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: my_org),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Image.network(
                                                        getdownloadUriFromDB(
                                                          cart.listItem[index]
                                                              .product.image,
                                                        ),
                                                        fit: BoxFit.contain,
                                                      )),
                                                  Container(
                                                    width: size.width * 0.25,
                                                    // color: Colors.red,
                                                    child: Center(
                                                      child: Text(
                                                        '${cart.listItem[index].product.productName}(${cart.listItem[index].product.unit})',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.width * 0.1,
                                                    // color: Colors.blue,
                                                    child: Center(
                                                      child: Text(
                                                        '${cart.listItem[index].count.toInt()}',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.width * 0.15,
                                                    // color: Colors.redAccent,
                                                    child: Center(
                                                      child: Text(
                                                        '\$${cart.listItem[index].newPrice.toStringAsFixed(2)}',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    // width: size.width * 0.1,
                                                    child: IconButton(
                                                      // color: Colors.white,
                                                      onPressed: () async {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              true,
                                                          builder: (context) =>
                                                              ConfirmDialog(
                                                            nameOfItem: cart
                                                                .listItem[index]
                                                                .product
                                                                .productName,
                                                            acceptFunc: () {
                                                              setState(() {
                                                                cart.removeItem(cart
                                                                    .listItem[
                                                                        index]
                                                                    .pId);
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.remove_circle,
                                                        color: Colors.redAccent,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                right: -10,
                                top: -10,
                                child: IconButton(
                                  // color: Colors.white,
                                  onPressed: () {
                                    if (supplierPicked == null) {
                                      Fluttertoast.showToast(
                                          msg: 'Please pick supplier',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.3),
                                          textColor: Colors.black,
                                          fontSize: 16.0);
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductsOfSupplier(
                                                  supplier: supplierPicked),
                                        ),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.blueGrey,
                                    size: 30,
                                  ),
                                ),
                              )
                            ]),
                            MyTextView(
                                content: "Total amount: \$${cart.totalAmount}"),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ShortButton(
                                  height: 40,
                                  width: size.width * 0.25,
                                  onclick: () async {
                                    if (supplierPicked == null) {
                                      Fluttertoast.showToast(
                                          msg: 'Please pick supplier',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.3),
                                          textColor: Colors.black,
                                          fontSize: 16.0);
                                    } else {
                                      if (cart.listItem.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: 'Empty Cart?...',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.3),
                                            textColor: Colors.black,
                                            fontSize: 16.0);
                                      } else {
                                        var import = new Import(
                                          date: datePicked,
                                          listProduct: cart.listItem,
                                          supplier: supplierPicked,
                                          totalAmount: cart.totalAmount,
                                        );
                                        SharedPreferences pre =
                                            await SharedPreferences
                                                .getInstance();
                                        var res = await ProductService()
                                            .importProduct(
                                                pre.getString('token'), import);
                                        if (res.statusCode == 200) {
                                          Fluttertoast.showToast(
                                              msg: 'Import complete...',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.3),
                                              textColor: Colors.black,
                                              fontSize: 16.0);
                                          cart.clear();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImportResult(
                                                        import: import,
                                                        listResult: jsonDecode(
                                                            res.body),
                                                      ))).then((value) =>
                                              Navigator.pop(context));
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: res.body,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.3),
                                              textColor: Colors.black,
                                              fontSize: 16.0);
                                        }
                                      }
                                    }
                                  },
                                  text: 'Submit',
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
                            )
                          ],
                        ),
                      )),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

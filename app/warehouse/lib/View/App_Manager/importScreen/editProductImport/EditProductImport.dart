import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/Models/cart.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/myDialog.dart';
import 'package:warehouse/components/myInputText.dart';
import 'package:warehouse/components/myTextView.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:warehouse/helper/actionToFile.dart';

class EditProductImport extends StatefulWidget {
  final User supplier;
  final CartItem cartItem;
  const EditProductImport(
      {Key key, @required this.cartItem, @required this.supplier})
      : super(key: key);

  @override
  _EditProductImportState createState() =>
      _EditProductImportState(cartItem, supplier);
}

class _EditProductImportState extends State<EditProductImport> {
  final CartItem cartItem;
  final User supplier;
  int qty;
  bool del;
  _EditProductImportState(this.cartItem, this.supplier);
  @override
  void initState() {
    // TODO: implement initState
    qty = cartItem.count;
    del = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
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
              child: Container(
                child: Form(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                          width: size.width,
                          child: Text(
                            'Edit quantity',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 24,
                                color: my_org,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      //listview
                      Positioned(
                        top: 30,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
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

                        child: Container(
                          child: Image.asset(
                            "assets/images/bgProduct.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // price and input
                      Positioned(
                        right: size.width * 0.05,
                        top: size.height * 0.3,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Import Price: \$${cartItem.newPrice}\nTempAmount: \$${cartItem.newPrice * qty}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
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
                                offset:
                                    Offset(0, 7), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Image.network(
                            getdownloadUriFromDB(cartItem.product.image),
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
                              "${cartItem.product.productName}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              "${cartItem.product.unit}",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "${supplier.name}",
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
                          child: Text("${cartItem.product.description}"),
                        ),
                      ),
//Btn
                      Positioned(
                        top: size.height * 0.7,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              size.width * 0.05, 0, size.width * 0.05, 0),
                          width: size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: size.height * 0.12,
                                width: size.width * 0.4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    ShortButton(
                                      height: 50,
                                      width: size.width * 0.1,
                                      onclick: () async {
                                        if (qty <= 1) {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  ConfirmDialog(
                                                    acceptFunc: () {
                                                      setState(() {
                                                        del = true;
                                                        cart.removeItem(
                                                            cartItem.pId);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  )).then((value) {
                                            if (del) {
                                              Navigator.pop(context);
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            qty--;
                                            cart.updateQuantity(
                                                cartItem.pId, qty);
                                          });
                                        }
                                      },
                                      text: '-',
                                    ),
                                    MyTextView(
                                      width: 50,
                                      height: 50,
                                      content: qty.toString(),
                                    ),
                                    ShortButton(
                                      height: 50,
                                      width: size.width * 0.1,
                                      onclick: () async {
                                        setState(() {
                                          qty++;
                                          cart.updateQuantity(
                                              cartItem.pId, qty);
                                        });
                                      },
                                      text: '+',
                                    ),
                                  ],
                                ),
                              ),
                              ShortButton(
                                height: 40,
                                width: size.width * 0.25,
                                onclick: () {
                                  Navigator.pop(context, false);
                                },
                                text: 'Back',
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
      ),
    );
  }
}

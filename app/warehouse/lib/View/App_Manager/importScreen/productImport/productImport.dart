import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/Models/cart.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/myInputText.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:warehouse/helper/actionToFile.dart';
import 'package:warehouse/helper/validation.dart';

class ProductImport extends StatefulWidget {
  final User supplier;
  final Product product;
  const ProductImport({Key key, @required this.product, this.supplier})
      : super(key: key);

  @override
  _ProductImportState createState() => _ProductImportState(product, supplier);
}

class _ProductImportState extends State<ProductImport> {
  final User supplier;
  final Product product;

  String qty;
  final _key = GlobalKey<FormState>();

  _ProductImportState(this.product, this.supplier);
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyDrawer(),
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
                  key: _key,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                          width: size.width,
                          child: Text(
                            'Import Product',
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
                        top: size.height * 0.25,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Import Price: \$${product.importPrice}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              MyInputText(
                                keytype: TextInputType.number,
                                controller: TextEditingController(text: qty),
                                width: size.width * 0.2,
                                onChanged: (val) {
                                  qty = val != '' ? val : null;
                                },
                                validator: (val) {
                                  return Validation.inputStringValidate(val);
                                },
                                label: 'Quantity?',
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
                            getdownloadUriFromDB(product.image),
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
                              "${product.productName}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              "${product.unit}",
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
                          child: Text("${product.description}"),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ShortButton(
                                height: 40,
                                width: size.width * 0.25,
                                onclick: () async {
                                  if (_key.currentState.validate()) {
                                    cart.addItem(product.id, int.parse(qty),
                                        product, product.importPrice);
                                    Fluttertoast.showToast(
                                        msg: 'Adding...',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.3),
                                        textColor: Colors.black,
                                        fontSize: 16.0);
                                    Navigator.pop(context, false);
                                  }
                                },
                                text: 'Add',
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
      ),
    );
  }
}

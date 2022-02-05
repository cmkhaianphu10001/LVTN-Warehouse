import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/position.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Services/positionService.dart';
import 'package:warehouse/Services/profileService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/ProductsScreen/QRList/QRListScreen.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/View/App_Manager/positionScreen/viewStorage/viewStorage.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/inkwell_link.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:warehouse/helper/Utils.dart';
import 'package:warehouse/helper/actionToFile.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key key, this.product}) : super(key: key);
  final Product product;

  @override
  _ProductDetailsScreenState createState() =>
      _ProductDetailsScreenState(product);
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final Product product;

  _ProductDetailsScreenState(this.product);
  Position position;

  Future getData(String supID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var user =
        ProfileServices().getUserById(preferences.getString('token'), supID);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyDrawer(),
      body: FutureBuilder(
        future: getData(product.supID),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Header(
                      title: 'Product',
                      userDrawer: false,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: size.height * 5 / 6,
                            child: Stack(
                              children: <Widget>[
                                //title
                                Positioned(
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    width: size.width,
                                    child: Text(
                                      'Product details infomation',
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
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                                  top: size.height * 0.1,
                                  child: Container(
                                    width: size.width * 0.4,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "current Price: \$${product.importPrice}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Rate Price: ${product.ratePrice}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Qty: ${product.quantity}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          QRListScreen(
                                                        product: product,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(Icons.next_plan),
                                                color: my_org,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: size.width * 0.4,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: InkWellLink(
                                                onclick: () async {
                                                  if (product.stored != null) {
                                                    SharedPreferences
                                                        preferences =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    position =
                                                        await PositionService()
                                                            .getPositionbyName(
                                                                preferences
                                                                    .getString(
                                                                        'token'),
                                                                product.stored);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewStorage(
                                                            position: position,
                                                          ),
                                                        ));
                                                  }
                                                },
                                                tag: 'Stored at: ' +
                                                    '${product.stored == null ? null.toString() : ""}',
                                                text:
                                                    '${product.stored == null ? "" : product.stored}',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                          offset: Offset(0,
                                              7), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                    ),
                                    child: Image.network(
                                      getdownloadUriFromDB(
                                        product.image,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        "${snapshot.data.name}",
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
                                  top: size.height * 0.5,
                                  left: size.width * 0.1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: size.height * 0.3,
                                    width: size.width * 0.7,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Container(
                                        width: size.width * 0.7,
                                        child: Text(
                                          "${product.description}",
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
//Btn
                                Positioned(
                                  top: size.height * 0.73,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        size.width * 0.05,
                                        0,
                                        size.width * 0.05,
                                        0),
                                    width: size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // ShortButton(
                                        //   height: 40,
                                        //   width: size.width * 0.6,
                                        //   onclick: () async {},
                                        //   text: 'Store in',
                                        // ),
                                        // ShortButton(
                                        //   height: 40,
                                        //   width: size.width * 0.25,
                                        //   onclick: () {
                                        //     Navigator.pop(context, false);
                                        //   },
                                        //   text: 'Cancel',
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: size.height * 0.7,
                            width: size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: size.height * 0.05,
                                      left: size.height * 0.05),
                                  child: Text(
                                    'Comment',
                                    style: TextStyle(
                                      color: my_org,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: size.height * 0.5,
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(20),
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(
                                            bottom: 10, right: 5, left: 1),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 2,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                        width: size.width,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                                flex: 1,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                )),
                                            Expanded(
                                              flex: 7,
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20))),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'UserName',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Something something something something something something ',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return MyLoading();
          }
        },
      ),
    );
  }
}

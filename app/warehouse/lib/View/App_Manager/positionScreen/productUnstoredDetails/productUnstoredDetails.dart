import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/position.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Services/positionService.dart';
import 'package:warehouse/Services/profileService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:warehouse/helper/Utils.dart';
import 'package:warehouse/helper/actionToFile.dart';

class ProductUnstoredDetails extends StatelessWidget {
  const ProductUnstoredDetails({Key key, this.product, this.position})
      : super(key: key);

  final Product product;
  final Position position;

  Future getData(String supID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return ProfileServices().getUserById(preferences.getString('token'), supID);
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
                      title: 'Unstored Product',
                      userDrawer: false,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          //title
                          Positioned(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              width: size.width,
                              child: Text(
                                'Store Product',
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
                                    height: 20,
                                  ),
                                  Text(
                                    "Store at: ${product.stored}",
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
                                    offset: Offset(
                                        0, 7), // changes position of shadow
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ShortButton(
                                    height: 40,
                                    width: size.width * 0.6,
                                    onclick: () async {
                                      SharedPreferences pre =
                                          await SharedPreferences.getInstance();

                                      var res = await PositionService().setItem(
                                          pre.getString('token'),
                                          product.id,
                                          position.positionName);
                                      myToast('Please wait...');
                                      if (res.statusCode == 200) {
                                        Navigator.pop(context);
                                        Navigator.pop(context, true);
                                      }
                                    },
                                    text: 'Store in ${position.positionName}',
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

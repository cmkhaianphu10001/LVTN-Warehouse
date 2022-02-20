import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/comment.dart';
import 'package:warehouse/Models/position.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Models/qrModel.dart';
import 'package:warehouse/Services/commentService.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/Services/profileService.dart';
import 'package:warehouse/View/App_Supplier/Header.dart';

import 'package:warehouse/colors.dart';

import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/actionToFile.dart';

class SupplierProductDetailsScreen extends StatefulWidget {
  const SupplierProductDetailsScreen({Key key, this.product}) : super(key: key);
  final Product product;

  @override
  _SupplierProductDetailsScreenState createState() =>
      _SupplierProductDetailsScreenState(product);
}

class _SupplierProductDetailsScreenState
    extends State<SupplierProductDetailsScreen> {
  final Product product;

  _SupplierProductDetailsScreenState(this.product);
  Position position;

  int count = 1;

  Future getSupplier(String supID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var user =
        ProfileServices().getUserById(preferences.getString('token'), supID);

    return user;
  }

  Future getQRs(String productID) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await ProductService()
        .getQRsByProductID(pre.getString('token'), productID);
  }

  Future getComments(String productID) async {
    return await CommentService().getCommentsOfProduct(productID);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: getSupplier(product.supID),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Header(),
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
                                  top: size.height * 0.3,
                                  child: Container(
                                    width: size.width * 0.3,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Price: \$${(product.importPrice * product.ratePrice).toStringAsFixed(2)}",
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
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Sold: ${product.sold}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
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
                              ],
                            ),
                          ),
                          FutureBuilder(
                              future: getComments(product.id),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  List<Comment> comments = snapshot.data;
                                  return Container(
                                    height: size.height * 0.6,
                                    width: size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        comments.length == 0
                                            ? Container()
                                            : Expanded(
                                                child: _listComment(
                                                  allComments: comments,
                                                  comments: comments
                                                      .where((e) =>
                                                          e.replyTo == null)
                                                      .toList(),
                                                ),
                                              )
                                      ],
                                    ),
                                  );
                                } else {
                                  return MyLoading();
                                }
                              }),
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

  Widget _listComment({
    @required List<Comment> comments,
    @required List<Comment> allComments,
  }) {
    return ListView.builder(
        padding: comments[0].replyTo == null
            ? EdgeInsets.only(left: 0)
            : EdgeInsets.only(left: 20),
        shrinkWrap: true,
        physics:
            comments[0].replyTo != null ? NeverScrollableScrollPhysics() : null,
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return _itemCard(comment: comments[index], allComments: allComments);
        });
  }

  Widget _itemCard({
    @required Comment comment,
    @required List<Comment> allComments,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  offset: Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.grey,
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        getdownloadUriFromDB(comment.userImage),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: Colors.grey[200]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${comment.userName}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('${comment.content}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        allComments.where((e) => e.replyTo == comment.id).toList().length == 0
            ? Container()
            : _listComment(
                comments:
                    allComments.where((e) => e.replyTo == comment.id).toList(),
                allComments: allComments,
              ),
      ],
    );
  }
}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/Comment.dart';
import 'package:warehouse/Models/cart.dart';
import 'package:warehouse/Models/position.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Models/qrModel.dart';
import 'package:warehouse/Services/commentService.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/Services/profileService.dart';
import 'package:warehouse/View/App_Customer/customer_header.dart';

import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/colors.dart';

import 'package:warehouse/components/inkwell_link.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/components/myInputTextArea.dart';
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

  int count = 1;
  String choiceRep = '';
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  countDown() {
    if (count > 1) {
      setState(() {
        count--;
      });
    }
  }

  countReset() {
    setState(() {
      count = 1;
    });
  }

  countUp() {
    if (count < product.quantity) {
      setState(() {
        count++;
      });
    }
  }

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
    final Cart cart = Provider.of<Cart>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyDrawer(),
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
                                            "Price: \$${product.importPrice * product.ratePrice}",
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
                                              FutureBuilder(
                                                  future: getQRs(product.id),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data != null) {
                                                      List<QRModel> qrs =
                                                          snapshot.data;
                                                      return Text(
                                                        "Sold: ${qrs.where((element) => element.cusID != null).toList().length}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      );
                                                    } else {
                                                      return MyLoading();
                                                    }
                                                  }),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              IconButton(
                                                onPressed: () {
                                                  countDown();
                                                },
                                                icon: Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text('${count}'),
                                              IconButton(
                                                onPressed: () {
                                                  countUp();
                                                },
                                                icon: Icon(
                                                  Icons.add_circle,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              CartItem item =
                                                  cart.listItem.firstWhere(
                                                (element) =>
                                                    element.pId == product.id,
                                                orElse: () => null,
                                              );

                                              if (item != null) {
                                                if (item.count + count <=
                                                    product.quantity) {
                                                  cart.addItem(
                                                      product.id,
                                                      count,
                                                      product,
                                                      product.importPrice *
                                                          product.ratePrice);
                                                  myToast('Done');
                                                } else {
                                                  myToast(
                                                      'Over quantity in Cart.');
                                                }
                                              } else {
                                                cart.addItem(
                                                    product.id,
                                                    count,
                                                    product,
                                                    product.importPrice *
                                                        product.ratePrice);
                                                myToast('Done');
                                              }
                                              log(cart.totalAmount.toString());
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: my_org,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 5,
                                                    offset: Offset(1, 1),
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.add_shopping_cart,
                                                      color: my_org_30,
                                                    ),
                                                    Text(
                                                      'Add to Cart',
                                                      style: TextStyle(
                                                        color: my_org_30,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                            : FutureBuilder(
                                                future: getComments(product.id),
                                                builder: (context, snapshot) {
                                                  if (snapshot.data != null) {
                                                    List<Comment> comments =
                                                        snapshot.data;
                                                    return Expanded(
                                                      child: _listComment(
                                                        allComments: comments,
                                                        comments: comments
                                                            .where((e) =>
                                                                e.replyTo ==
                                                                null)
                                                            .toList(),
                                                      ),
                                                    );
                                                  } else {
                                                    return MyLoading();
                                                  }
                                                }),
                                        _inputComment(
                                          controller: controller1,
                                          onPressed: () async {
                                            if (controller1.text.length != 0) {
                                              log(controller1.text);
                                              await CommentService()
                                                  .addComment(new Comment(
                                                id: null,
                                                productID: product.id,
                                                content: controller1.text,
                                                replyTo: null,
                                              ));
                                              controller1.clear();

                                              setState(() {
                                                countReset();
                                              });
                                            } else {
                                              log('comment...');
                                            }
                                          },
                                        ),
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

  _inputComment({
    @required Function onPressed,
    @required TextEditingController controller,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Comment...',
          focusColor: my_org,
          suffixIcon: IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.send,
              color: my_org,
            ),
          ),
        ),
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
              InkWellLink(
                tag: '',
                text: 'Reply',
                onclick: () {
                  setState(() {
                    choiceRep = comment.id;
                  });
                },
              ),
              choiceRep == comment.id
                  ? _inputComment(
                      controller: controller2,
                      onPressed: () async {
                        if (controller2.text.length != 0) {
                          log(controller2.text);
                          await CommentService().addComment(new Comment(
                            id: null,
                            productID: product.id,
                            content: controller2.text,
                            replyTo: comment.id,
                          ));
                          controller2.clear();

                          setState(() {
                            countReset();
                          });
                        } else {
                          log('comment...');
                        }
                      },
                    )
                  : Container(),
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

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Services/OrderService.dart';
import 'package:warehouse/Services/cartDatabase.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/View/App_Customer/cusProducts/ProductDetailsScreen/ProductDetailsScreen.dart';
import 'package:warehouse/View/App_Customer/customer_header.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/Utils.dart';
import 'package:warehouse/helper/actionToFile.dart';

class CustomerCartScreen extends StatefulWidget {
  const CustomerCartScreen({Key key, @required this.myID}) : super(key: key);
  final String myID;
  @override
  CustomerCartScreenState createState() => CustomerCartScreenState(myID);
}

class CustomerCartScreenState extends State<CustomerCartScreen> {
  final String myID;

  List<Product> products;
  List<dynamic> listCartItemData;
  Stream cartStream, cartItemsStream;
  List<Map<String, dynamic>> jsonListCartItem;

  CustomerCartScreenState(this.myID);

  getProducts() async {
    SharedPreferences pre = await SharedPreferences.getInstance();

    return ProductService().getProducts(pre.getString('token'));
  }

  @override
  void initState() {
    cartStream = CartDatabase().cartStream(myID: myID);
    cartItemsStream = CartDatabase().cartItemsStream(myID: myID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Header(),
        ),
        Expanded(
          flex: 5,
          child: FutureBuilder(
              future: getProducts(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  products = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          'Cart',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 24,
                              color: my_org,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: listCartItem(),
                      ),
                    ],
                  );
                } else {
                  return MyLoading();
                }
              }),
        ),
        Expanded(
          flex: 1,
          child: action(),
        ),
      ],
    ));
  }

  Widget listCartItem() {
    return StreamBuilder(
        stream: cartItemsStream,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            listCartItemData = snapshot.data.docs;
            cartItemsStream.listen(
              (event) async {
                await CartDatabase().updateQuantity(myID: myID);
              },
            );

            return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                itemCount: listCartItemData.length,
                itemBuilder: (context, index) {
                  Product product = products.firstWhere((element) =>
                      listCartItemData[index]['productID'] == element.id);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(product: product),
                          ));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 15,
                              offset: Offset(3, 3),
                            ),
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 15,
                              offset: Offset(-4, -4),
                            ),
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: CircleAvatar(
                              maxRadius: 30,
                              backgroundImage: NetworkImage(
                                  getdownloadUriFromDB(product.image)),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${product.productName}"),
                                Text("\$${listCartItemData[index]['price']}"),
                                Text(
                                    "Stored: ${product.quantity} - unit: ${product.unit}"),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        CartDatabase().subtract1QtyItem(
                                            myID: myID, product: product);
                                      },
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: my_org,
                                      ),
                                    ),
                                    Text("${listCartItemData[index]['count']}"),
                                    IconButton(
                                      onPressed: () {
                                        CartDatabase().plus1QtyItem(
                                            myID: myID, product: product);
                                      },
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: my_org,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Remove Product'),
                                    content: Text(
                                        'Remove ${product.productName} in Cart'),
                                    actions: [
                                      IconButton(
                                        onPressed: () {
                                          CartDatabase().removeItem(
                                              myID: myID, product: product);
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.check,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.cancel,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return MyLoading();
          }
        });
  }

  Widget action() {
    return StreamBuilder(
      stream: cartStream,
      builder: (context, snap) {
        if (snap.data != null) {
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Total Amount"),
                      Text(
                        "\$${snap.data['totalAmount']}",
                        style: TextStyle(
                          color: my_org,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    jsonListCartItem = listCartItemData
                        .map((e) => {
                              'productID': e['productID'],
                              'count': e['count'],
                              'newPrice': e['price'],
                            })
                        .toList();
                    var res = await OrderService().addOrder(
                      cusID: myID,
                      totalAmount: snap.data['totalAmount'],
                      itemCart: jsonListCartItem,
                    );
                    myToast(res.body.toString());
                    if (res.statusCode == 200) {
                      CartDatabase().clearCart(myID: myID);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Container(
                      height: 300,
                      width: 300,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(3, 3),
                          ),
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 5,
                            offset: Offset(-4, -4),
                          ),
                        ],
                      ),
                      child: Text(
                        'Order',
                        style: TextStyle(
                          color: my_org,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return MyLoading();
        }
      },
    );
  }
}

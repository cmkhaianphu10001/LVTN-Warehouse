import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:warehouse/Models/orderModel.dart';
import 'package:warehouse/Services/OrderService.dart';
import 'package:warehouse/View/App_Customer/cusProducts/ProductDetailsScreen/ProductDetailsScreen.dart';
import 'package:warehouse/View/App_Customer/customer_header.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/LongButton.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/Utils.dart';
import 'package:warehouse/helper/actionToFile.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key key, @required this.orderID}) : super(key: key);
  final String orderID;

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState(orderID);
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final String orderID;

  _OrderDetailsScreenState(this.orderID);
  bool load = false;
  OrderModel orderModel;

  getOrderByID() async {
    return await OrderService().getOrdersByID(orderID: orderID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Header(),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    'Order Details',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 24,
                        color: my_org,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: getOrderByID(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(color: Colors.white),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${getProcess(snapshot.data.process)}',
                                      style: TextStyle(
                                        color: my_org,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    snapshot.data.description != null
                                        ? Text(
                                            '${getProcess(snapshot.data.description)}',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data.itemOfOrders.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(10),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailsScreen(
                                                      product: snapshot
                                                          .data
                                                          .itemOfOrders[index]
                                                          .product),
                                            ));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                          ],
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                height: 70,
                                                width: 70,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Image(
                                                    image: NetworkImage(
                                                      getdownloadUriFromDB(
                                                          snapshot
                                                              .data
                                                              .itemOfOrders[
                                                                  index]
                                                              .product
                                                              .image),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '${snapshot.data.itemOfOrders[index].product.productName}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${snapshot.data.itemOfOrders[index].product.unit}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Stored: ${snapshot.data.itemOfOrders[index].product.quantity}',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'x${snapshot.data.itemOfOrders[index].count}',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Text(
                                                    '\$${snapshot.data.itemOfOrders[index].newPrice}',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(color: Colors.white),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    'total Amount \n\$${snapshot.data.totalAmount}'),
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(color: Colors.white),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Order ID'),
                                          Text('Order Date'),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text('${snapshot.data.id}'),
                                          Text(
                                              '${snapshot.data.orderDate.day} - ${snapshot.data.orderDate.month} - ${snapshot.data.orderDate.year} '),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              snapshot.data.process == 1
                                  ? Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.all(20),
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      alignment: Alignment.center,
                                      child: LongButton(
                                        onclick: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Cancel Order'),
                                              content: Text('Cancel order?'),
                                              actions: [
                                                IconButton(
                                                  onPressed: () async {
                                                    await OrderService()
                                                        .deleteOrder(
                                                            orderID: orderID);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Icon(Icons.check),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Icon(Icons.cancel),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        text: 'Cancel Order',
                                        toastText: 'Please wait',
                                      ))
                                  : Container(),
                              snapshot.data.process == 3
                                  ? Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.all(20),
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      alignment: Alignment.center,
                                      child: LongButton(
                                        onclick: () async {
                                          var res = await OrderService()
                                              .changeStateOrder(
                                                  orderID: orderID, state: 4);
                                          if (res.statusCode == 200) {
                                            setState(() {
                                              load = true;
                                            });
                                            Navigator.pop(context);
                                          }
                                          myToast(res.body);
                                        },
                                        text: 'Took Deliveries',
                                        toastText: 'Please wait',
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        );
                      } else {
                        return MyLoading();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

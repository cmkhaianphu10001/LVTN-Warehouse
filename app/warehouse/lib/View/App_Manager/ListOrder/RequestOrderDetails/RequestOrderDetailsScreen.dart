import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/orderModel.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/OrderService.dart';
import 'package:warehouse/Services/profileService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/ListOrder/exportItemByOrder/ExportItemByOrder.dart';
import 'package:warehouse/View/App_Manager/ProductsScreen/productDetail/productDetailScreen.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/LongButton.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:warehouse/helper/Utils.dart';
import 'package:warehouse/helper/actionToFile.dart';

class RequestOrderDetailsScreen extends StatefulWidget {
  const RequestOrderDetailsScreen({Key key, @required this.orderID})
      : super(key: key);
  final String orderID;

  @override
  _RequestOrderDetailsScreenState createState() =>
      _RequestOrderDetailsScreenState(orderID);
}

class _RequestOrderDetailsScreenState extends State<RequestOrderDetailsScreen> {
  final String orderID;
  bool load = false;
  OrderModel orderModel;
  TextEditingController description = new TextEditingController();

  _RequestOrderDetailsScreenState(this.orderID);
  getOrderByID() async {
    return await OrderService().getOrdersByID(orderID: orderID);
  }

  getCustomer(String customerID) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await ProfileServices()
        .getUserById(pre.getString('token'), customerID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Header(
              title: 'Details Order',
              userDrawer: false,
            ),
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
                        orderModel = snapshot.data;
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
                                      '${getProcess(orderModel.process)}',
                                      style: TextStyle(
                                        color: my_org,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    orderModel.description != null
                                        ? Text(
                                            '${orderModel.description}',
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
                                  itemCount: orderModel.itemOfOrders.length,
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
                                                      '${orderModel.itemOfOrders[index].product.productName}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${orderModel.itemOfOrders[index].product.unit}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Stored: ${orderModel.itemOfOrders[index].product.quantity}',
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
                                                    'x${orderModel.itemOfOrders[index].count}',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Text(
                                                    '\$${orderModel.itemOfOrders[index].newPrice}',
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
                                    'total Amount \n\$${orderModel.totalAmount}'),
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
                                          Text('${orderModel.id}'),
                                          Text(
                                              '${orderModel.orderDate.day} - ${orderModel.orderDate.month} - ${orderModel.orderDate.year} '),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              FutureBuilder(
                                future: getCustomer(orderModel.cusID),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    User customer = snapshot.data;
                                    return Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.all(20),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                getdownloadUriFromDB(
                                                    customer.image),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  '${customer.name}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  '${customer.email}',
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                )
                                              ],
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
                              snapshot.data.process == 1
                                  ? Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.all(20),
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ShortButton(
                                            onclick: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text('Denie Order'),
                                                  content: TextField(
                                                    controller: description,
                                                    maxLines: null,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    decoration: InputDecoration(
                                                      label:
                                                          Text('Reason denie'),
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    IconButton(
                                                      onPressed: () async {
                                                        await OrderService()
                                                            .changeStateOrder(
                                                                orderID:
                                                                    orderID,
                                                                state: 0,
                                                                description:
                                                                    description
                                                                        .text);
                                                        description.text = '';
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
                                            text: 'Denie',
                                            toastText: 'Please wait',
                                          ),
                                          ShortButton(
                                            onclick: () async {
                                              await OrderService()
                                                  .changeStateOrder(
                                                      orderID: orderID,
                                                      state: 2);
                                              setState(() {
                                                load = true;
                                              });
                                            },
                                            text: 'Accept',
                                            toastText: 'Please wait',
                                          ),
                                        ],
                                      ))
                                  : Container(),
                              snapshot.data.process == 2
                                  ? Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.all(20),
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ShortButton(
                                            onclick: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text('Denie Order'),
                                                  content: TextField(
                                                    controller: description,
                                                    maxLines: null,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    decoration: InputDecoration(
                                                      label:
                                                          Text('Reason denie'),
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    IconButton(
                                                      onPressed: () async {
                                                        await OrderService()
                                                            .changeStateOrder(
                                                                orderID:
                                                                    orderID,
                                                                state: 0,
                                                                description:
                                                                    description
                                                                        .text);
                                                        description.text = '';
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
                                            text: 'Denie',
                                            toastText: 'Please wait',
                                          ),
                                          ShortButton(
                                            onclick: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ExportItemByOrder(
                                                            orderModel:
                                                                orderModel),
                                                  )).then((value) {
                                                setState(() {
                                                  load = true;
                                                });
                                              });
                                            },
                                            text: 'Export',
                                            toastText: 'Please wait',
                                          ),
                                        ],
                                      ))
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

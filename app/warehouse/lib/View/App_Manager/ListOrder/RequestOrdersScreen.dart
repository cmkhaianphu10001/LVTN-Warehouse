import 'package:flutter/material.dart';
import 'package:warehouse/Models/orderModel.dart';

import 'package:warehouse/Services/OrderService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/ListOrder/RequestOrderDetails/RequestOrderDetailsScreen.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/Utils.dart';
import 'package:warehouse/helper/actionToFile.dart';

class RequestOrdersScreen extends StatefulWidget {
  const RequestOrdersScreen({Key key}) : super(key: key);

  @override
  _RequestOrdersScreenState createState() => _RequestOrdersScreenState();
}

class _RequestOrdersScreenState extends State<RequestOrdersScreen> {
  bool load = false;
  int countProcess = 1;
  getOrders() async {
    return await OrderService().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyDrawer(),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Header(title: 'Request Orders', userDrawer: false),
          ),
          Expanded(
            flex: 5,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      'Orders',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 24,
                          color: my_org,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                countProcess = 0;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: countProcess == 0
                                      ? [
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
                                        ]
                                      : null),
                              child: Text(
                                'Denie',
                                style: TextStyle(color: my_org),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                countProcess = 1;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: countProcess == 1
                                      ? [
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
                                        ]
                                      : null),
                              child: Text(
                                'Checking',
                                style: TextStyle(color: my_org),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                countProcess = 2;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: countProcess == 2
                                      ? [
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
                                        ]
                                      : null),
                              child: Text(
                                'Accepted',
                                style: TextStyle(color: my_org),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                countProcess = 3;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: countProcess == 3
                                      ? [
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
                                        ]
                                      : null),
                              child: Text(
                                'Exported',
                                style: TextStyle(color: my_org),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                countProcess = 4;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: countProcess == 4
                                      ? [
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
                                        ]
                                      : null),
                              child: Text(
                                'Completed',
                                style: TextStyle(color: my_org),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: listOrdersView(size),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  listOrdersView(Size size) {
    return FutureBuilder(
      future: getOrders(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          List<OrderModel> orders = (snapshot.data as List)
              .where((element) => element.process == countProcess)
              .toList();
          return ListView.builder(
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestOrderDetailsScreen(
                            orderID: orders[index].id),
                      )).then((value) {
                    setState(() {
                      load = true;
                    });
                  });
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
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${getProcess(orders[index].process)}',
                        style: TextStyle(
                          color: my_org,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: Container(
                                height: 70,
                                width: 70,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Image(
                                    image: NetworkImage(
                                      getdownloadUriFromDB(orders[index]
                                          .itemOfOrders[0]
                                          .product
                                          .image),
                                    ),
                                  ),
                                ),
                              )),
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${orders[index].itemOfOrders[0].product.productName}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${orders[index].itemOfOrders[0].product.unit}',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'x${orders[index].itemOfOrders[0].count}',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '\$${orders[index].itemOfOrders[0].newPrice}',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 1,
                        width: size.width,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                                '${orders[index].itemOfOrders.length} ${orders[index].itemOfOrders.length != 1 ? "items" : "item"}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  'TotalAmount \$${orders[index].totalAmount}'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return MyLoading();
        }
      },
    );
  }
}

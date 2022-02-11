import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/cart.dart';
import 'package:warehouse/Models/orderModel.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/OrderService.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/Services/profileService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/ProductsScreen/productDetail/productDetailScreen.dart';
import 'package:warehouse/View/App_Manager/exportScreen/ScanAddExport/ScanAddExport.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:warehouse/helper/Utils.dart';
import 'package:warehouse/helper/actionToFile.dart';

class ExportItemByOrder extends StatefulWidget {
  const ExportItemByOrder(
      {Key key, @required this.orderModel, @required this.customer})
      : super(key: key);
  final OrderModel orderModel;
  final User customer;

  @override
  _ExportItemByOrderState createState() =>
      _ExportItemByOrderState(orderModel, customer);
}

class _ExportItemByOrderState extends State<ExportItemByOrder> {
  final OrderModel orderModel;
  _ExportItemByOrderState(this.orderModel, this.customer);

  bool load = false;
  final User customer;

  TextEditingController description = new TextEditingController();

  getCustomer(String customerID) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await ProfileServices()
        .getUserById(pre.getString('token'), customerID);
  }

  @override
  void initState() {
    super.initState();
    log(customer.id);
  }

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 20,
            top: size.height * 0.6,
            child: FloatingActionButton(
              heroTag: 'clear',
              backgroundColor: Colors.red[700],
              child: Icon(Icons.remove),
              onPressed: () {
                cart.clear();
              },
            ),
          ),
          Positioned(
            right: 20,
            top: size.height * 0.25,
            child: FloatingActionButton(
              heroTag: 'scan',
              backgroundColor: my_org,
              child: Icon(Icons.qr_code_scanner),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScanAddExport(),
                    )).then((value) {
                  setState(() {
                    load = true;
                  });
                });
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Header(
              title: 'Export Order',
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
                    'Export Item by Order',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 24,
                        color: my_org,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
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
                                'List Product',
                                style: TextStyle(
                                  color: my_org,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: orderModel.itemOfOrders.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              OrderItemModel orderItemModel =
                                  orderModel.itemOfOrders[index];
                              CartItem cartItem = cart.listItem.firstWhere(
                                  (CartItem element) =>
                                      element.pId ==
                                      orderModel.itemOfOrders[index].productID,
                                  orElse: () => CartItem(
                                        pId: orderItemModel.productID,
                                        product: orderItemModel.product,
                                        count: 0,
                                        newPrice: double.parse((orderItemModel
                                                    .product.importPrice *
                                                orderItemModel
                                                    .product.ratePrice)
                                            .toStringAsFixed(2)),
                                      ));

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsScreen(
                                                product: orderModel
                                                    .itemOfOrders[index]
                                                    .product),
                                      )).then((value) {
                                    setState(() {
                                      load = true;
                                    });
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color:
                                        orderItemModel.count == cartItem.count
                                            ? Colors.green[100]
                                            : Colors.red[100],
                                    borderRadius: BorderRadius.circular(20),
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
                                                getdownloadUriFromDB(orderModel
                                                    .itemOfOrders[index]
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
                                          padding: const EdgeInsets.all(8.0),
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
                                                  fontWeight: FontWeight.bold,
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
                                                  fontStyle: FontStyle.italic,
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
                                              ' ${cartItem.count}/${orderModel.itemOfOrders[index].count}',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Order ID'),
                                    Text('Order Date'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    getdownloadUriFromDB(customer.image),
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
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(color: Colors.white),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ShortButton(
                                  onclick: () async {
                                    Map<String, dynamic> cartItemMap = {};
                                    cart.listItem
                                        .forEach((e) => cartItemMap.putIfAbsent(
                                              e.pId,
                                              () => e.count,
                                            ));
                                    Map<String, dynamic> orderItemMap = {};
                                    orderModel.itemOfOrders.forEach(
                                        (OrderItemModel e) =>
                                            orderItemMap.putIfAbsent(
                                                e.productID, () => e.count));
                                    if (compare2Json(
                                        cartItemMap, orderItemMap)) {
                                      var export = new Export(
                                        date: DateTime.now(),
                                        listProduct: cart.listItem,
                                        customer: customer,
                                        totalAmount: cart.totalAmount,
                                        listQRID: cart.listQR,
                                      );
                                      SharedPreferences pre =
                                          await SharedPreferences.getInstance();
                                      var res = await ProductService()
                                          .exportProduct(
                                              pre.getString('token'), export);
                                      if (res.statusCode == 200) {
                                        var res2 = await OrderService()
                                            .changeStateOrder(
                                                orderID: orderModel.id,
                                                state: 3);
                                        if (res2.statusCode == 200) {
                                          Navigator.pop(context);
                                          myToast(res.body);
                                          cart.clear();
                                        }
                                      } else {
                                        myToast(res.body);
                                      }
                                    } else {
                                      myToast('Keep all Product green');
                                    }
                                  },
                                  text: 'Export',
                                  toastText: 'Please wait',
                                ),
                                ShortButton(
                                  onclick: () async {
                                    Navigator.pop(context);
                                  },
                                  text: 'Cancel',
                                  toastText: 'Please wait',
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

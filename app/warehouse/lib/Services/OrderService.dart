import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/orderModel.dart';

import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/colors.dart';
import 'package:http/http.dart' as http;

class OrderService {
  // SharedPreferences pre = await SharedPreferences.getInstance();
  var url = domain + 'api/order/';

  addOrder({
    @required String cusID,
    @required double totalAmount,
    @required List<Map<String, dynamic>> itemCart,
  }) async {
    DateTime today = DateTime.now();
    SharedPreferences pre = await SharedPreferences.getInstance();

    try {
      var res = await http.post(
        Uri.parse(url + 'addOrder'),
        headers: {
          "content-type": "application/json",
          "authorization": pre.getString('token'),
        },
        body: jsonEncode({
          'totalAmount': totalAmount,
          'orderDate': DateTime.now().toString(),
          'cusId': cusID,
          'listItem': itemCart,
        }),
      );
      log(res.body.toString());
      return res;
    } catch (e) {
      log(e.message);
    }
  }

  deleteOrder({@required String orderID}) async {
    SharedPreferences pre = await SharedPreferences.getInstance();

    try {
      var res = await http.post(
        Uri.parse(url + 'deleteOrder'),
        headers: {
          "content-type": "application/json",
          "authorization": pre.getString('token'),
        },
        body: jsonEncode({
          'orderTargetID': orderID,
        }),
      );
      log(res.body.toString());
      return res;
    } catch (e) {
      log(e.message);
    }
  }

  getOrders({String customerID}) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    try {
      var res = await http.get(
        Uri.parse(url + 'getOrders'),
        headers: customerID != null
            ? {
                "content-type": "application/json",
                "authorization": pre.getString('token'),
                'cusid': customerID,
              }
            : {
                "content-type": "application/json",
                "authorization": pre.getString('token'),
              },
      );
      List<OrderModel> orders = (jsonDecode(res.body) as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();

      orders.sort(
        (a, b) => b.orderDate.compareTo(a.orderDate),
      );
      List<OrderItemModel> orderItems = await getOrderItems();
      List<Product> products =
          await ProductService().getProducts(pre.getString('token'));
      for (OrderModel order in orders) {
        order.itemOfOrders =
            orderItems.where((e) => e.parentID == order.id).toList();
        for (OrderItemModel orderItem in order.itemOfOrders) {
          orderItem.product = products
              .firstWhere((element) => element.id == orderItem.productID);
        }
      }
      return orders;
    } catch (e) {
      log(e.message);
    }
  }

  getOrdersByID({String orderID}) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    try {
      var res = await http.get(
        Uri.parse(url + 'getOrders'),
        headers: {
          "content-type": "application/json",
          "authorization": pre.getString('token'),
          'orderid': orderID,
        },
      );
      OrderModel order = OrderModel.fromJson(jsonDecode(res.body));

      List<OrderItemModel> orderItems = await getOrderItems();
      List<Product> products =
          await ProductService().getProducts(pre.getString('token'));

      order.itemOfOrders =
          orderItems.where((e) => e.parentID == order.id).toList();
      for (OrderItemModel orderItem in order.itemOfOrders) {
        orderItem.product =
            products.firstWhere((element) => element.id == orderItem.productID);
      }
      return order;
    } catch (e) {
      log(e.message);
    }
  }

  getOrderItems() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    try {
      var resItemOfOrder = await http.get(
        Uri.parse(url + 'getItemsOfOrder'),
        headers: {
          "content-type": "application/json",
          "authorization": pre.getString('token'),
        },
      );
      List<OrderItemModel> orderItems =
          (jsonDecode(resItemOfOrder.body) as List)
              .map((e) => OrderItemModel.fromjson(e))
              .toList();
      return orderItems;
    } catch (e) {
      log(e.message);
    }
  }

  changeStateOrder({
    @required String orderID,
    @required int state,
    String description,
  }) async {
    SharedPreferences pre = await SharedPreferences.getInstance();

    try {
      var res = await http.post(
        Uri.parse(url + 'changeStateOrder'),
        headers: {
          "content-type": "application/json",
          "authorization": pre.getString('token'),
        },
        body: jsonEncode({
          'orderid': orderID,
          'state': state,
          'description': description,
        }),
      );
      log(res.body.toString());
      return res;
    } catch (e) {
      log(e.message);
    }
  }
}

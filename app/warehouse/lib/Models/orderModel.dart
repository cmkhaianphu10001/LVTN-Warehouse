import 'package:warehouse/Models/productModel.dart';

class OrderModel {
  String id;
  String cusID;
  DateTime orderDate;
  int process;
  double totalAmount;
  List<OrderItemModel> itemOfOrders;
  String description;
  OrderModel({
    this.id,
    this.cusID,
    this.orderDate,
    this.process,
    this.totalAmount,
    this.itemOfOrders,
    this.description,
  });

  OrderModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        cusID = json['cusID'],
        orderDate = DateTime.parse(json['orderDate'].toString()),
        process = int.parse(json['process'].toString()),
        totalAmount = double.parse(json['totalAmount'].toString()),
        description = json['description'] ?? null;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'cusID': cusID,
        'orderDate': orderDate,
        'process': process,
        'totalAmount': totalAmount,
        'description': description,
      };
}

class OrderItemModel {
  String id;
  String parentID;
  String productID;
  Product product;
  double newPrice;
  int count;

  OrderItemModel({
    this.id,
    this.parentID,
    this.productID,
    this.product,
    this.newPrice,
    this.count,
  });

  OrderItemModel.fromjson(Map<String, dynamic> json)
      : id = json['_id'],
        parentID = json['parentID'],
        productID = json['productID'],
        count = int.parse(json['count'].toString()),
        newPrice = double.parse(json['newPrice'].toString());

  Map<String, dynamic> toJson() => {
        '_id': id,
        'parentID': parentID,
        'productID': productID,
        'count': count,
        'newPrice': newPrice,
      };
}

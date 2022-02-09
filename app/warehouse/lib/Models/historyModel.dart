import 'package:warehouse/Models/qrModel.dart';

class HistoryModel {
  String id;
  String typeHistory;
  DateTime date;
  String userTargetID;
  String managerID;
  double totalAmount;
  List<ItemOfHistory> listProduct;
  HistoryModel({
    this.id,
    this.typeHistory,
    this.date,
    this.userTargetID,
    this.managerID,
    this.listProduct,
    this.totalAmount,
  });

  HistoryModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        typeHistory = json['typeHistory'],
        date = DateTime.parse(json['date'].toString()),
        userTargetID = json['userTargetID'],
        managerID = json['managerID'],
        totalAmount = double.parse(json['totalAmount'].toString());
}

class ItemOfHistory {
  String id;
  String parentID;
  String productID;
  int count;
  List<QRModel> qrs;

  ItemOfHistory({
    this.id,
    this.parentID,
    this.productID,
    this.count,
    this.qrs,
  });

  ItemOfHistory.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        parentID = json['parentID'],
        productID = json['productID'],
        count = json['count'];
}

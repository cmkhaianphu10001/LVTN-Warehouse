class QRModel {
  String id;
  String productID;
  DateTime impotDate;
  String managerIDImport;
  String cusID;
  DateTime exportDate;
  String managerIDExport;
  double exportPrice;
  String locationID;

  QRModel({
    this.id,
    this.productID,
    this.impotDate,
    this.managerIDImport,
    this.cusID,
    this.exportDate,
    this.managerIDExport,
    this.exportPrice,
    this.locationID,
  });
  // DateTime date = new DateTime()
  QRModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        productID = json['productID'] ?? '',
        impotDate = json['impotDate'] != null
            ? DateTime.parse(json['impotDate'])
            : DateTime.now(),
        managerIDImport = json['managerIDImport'] ?? 0,
        cusID = json['cusID'] ?? null,
        exportDate = json['exportDate'] != null
            ? DateTime.parse(json['exportDate'])
            : null,
        managerIDExport = json['managerIDExport'] ?? null,
        exportPrice = json['exportPrice'] != null
            ? double.parse(json['exportPrice'].toString())
            : null,
        locationID = json['locationID'] ?? null;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'productID': productID,
        'impotDate': impotDate,
        'managerIDImport': managerIDImport,
        'cusID': cusID,
        'exportDate': exportDate,
        'managerIDExport': managerIDExport,
        'exportPrice': exportPrice,
        'locationID': locationID,
      };
}

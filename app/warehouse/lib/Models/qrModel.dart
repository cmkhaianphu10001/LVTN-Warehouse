class QRModel {
  String id;
  String productID;
  DateTime importDate;
  String managerIDImport;
  String cusID;
  DateTime exportDate;
  String managerIDExport;
  double exportPrice;

  String importIDhistory;
  String exportIDhistory;

  QRModel({
    this.id,
    this.productID,
    this.importDate,
    this.managerIDImport,
    this.cusID,
    this.exportDate,
    this.managerIDExport,
    this.exportPrice,
    this.importIDhistory,
    this.exportIDhistory,
  });
  // DateTime date = new DateTime()
  QRModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        productID = json['productID'] ?? '',
        importDate = json['importDate'] != null
            ? DateTime.parse(json['importDate'])
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
        importIDhistory = json['importIDhistory'] ?? null,
        exportIDhistory = json['exportIDhistory'] ?? null;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'productID': productID,
        'impotDate': importDate,
        'managerIDImport': managerIDImport,
        'cusID': cusID,
        'exportDate': exportDate,
        'managerIDExport': managerIDExport,
        'exportPrice': exportPrice,
        'importIDhistory': importIDhistory,
        'exportIDhistory': exportIDhistory,
      };
}

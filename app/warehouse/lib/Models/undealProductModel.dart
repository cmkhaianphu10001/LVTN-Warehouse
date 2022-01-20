class UndealProduct {
  String id;
  String productName;
  String unit;
  int quantity;
  String supID;
  double importPrice;
  double ratePrice;
  String image;
  String description;
  bool supplierConfirm;
  bool managerConfirm;

  UndealProduct({
    this.id,
    this.productName,
    this.unit,
    this.quantity = 0,
    this.supID,
    this.importPrice,
    this.ratePrice,
    this.image = '',
    this.description = '',
    this.managerConfirm = false,
    this.supplierConfirm = false,
  });

  UndealProduct.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        productName = json['productName'] ?? '',
        unit = json['unit'] ?? '',
        quantity = json['quantity'] ?? 0,
        supID = json['supID'] ?? '',
        description = json['description'] ?? '',
        image = json['image'] ?? '',
        ratePrice = json['ratePrice'] != null
            ? double.parse(json['ratePrice'].toString())
            : 1,
        importPrice = json['importPrice'] != null
            ? double.parse(json['importPrice'].toString())
            : 0,
        supplierConfirm = json['supplierConfirm'] ?? false,
        managerConfirm = json['managerConfirm'] ?? false;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'productName': productName,
        'unit': unit,
        'quantity': quantity,
        'supID': supID,
        'importPrice': importPrice,
        'description': description,
        'image': image,
        'ratePrice': ratePrice,
        'supplierConfirm': supplierConfirm,
        'managerConfirm': managerConfirm,
      };
}

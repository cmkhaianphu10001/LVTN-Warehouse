class Position {
  String id;
  String description;
  String positionName;
  String productID;
  String image;
  String productName;

  Position({
    this.id,
    this.description,
    this.positionName,
    this.productID,
    this.image,
    this.productName,
  });

  Position.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        description = json['description'],
        positionName = json['positionName'],
        productID = json['productID'] ?? null,
        image = json['image'] ?? null,
        productName = json['productName'] ?? null;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'description': description,
        'positionName': positionName,
        'productID': productID,
        'image': image,
        'productName': productName
      };
}

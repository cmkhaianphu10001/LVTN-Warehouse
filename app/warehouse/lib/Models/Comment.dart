class Comment {
  String id;
  String productID;
  String userID;
  String userName;
  String userImage;
  String content;
  String replyTo;

  Comment({
    this.id,
    this.productID,
    this.userID,
    this.userName,
    this.userImage,
    this.content,
    this.replyTo,
  });

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        productID = json['productID'],
        userID = json['userID'],
        userName = json['userName'],
        userImage = json['userImage'],
        content = json['content'],
        replyTo = json['replyTo'] ?? null;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'productID': productID,
        'userID': userID,
        'userName': userName,
        'userImage': userImage,
        'content': content,
        'replyTo': replyTo
      };
}

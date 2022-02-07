class User {
  String id;
  String name;
  String password;
  String address;
  String email;
  String phone;
  String description;
  String image;
  String role;
  bool verify;
  DateTime lastMessTime;
  User({
    this.id,
    this.name,
    this.email,
    this.address,
    this.description = '',
    this.password,
    this.phone,
    this.image = '',
    this.verify = false,
    this.role = '',
    this.lastMessTime,
  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        id = json['_id'] ?? '',
        password = json['password'] ?? '',
        address = json['address'] ?? '',
        email = json['email'] ?? '',
        phone = json['phone'] ?? '',
        description = json['description'] ?? '',
        image = json['image'] ?? '',
        verify = json['verify'] ?? false,
        role = json['role'] ?? '',
        lastMessTime = json['lastMessTime'] != null
            ? DateTime.parse(json['lastMessTime'])
            : DateTime.now();

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'password': password,
        'address': address,
        'email': email,
        'phone': phone,
        'description': description,
        'image': image,
        'verify': verify,
        'role': role,
        'lastMessTime': lastMessTime,
      };
}

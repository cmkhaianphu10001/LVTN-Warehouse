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
  User(
      {this.id,
      this.name,
      this.email,
      this.address,
      this.description = '',
      this.password,
      this.phone,
      this.image = '',
      this.verify = false,
      this.role = ''});

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
        role = json['role'] ?? '';

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
      };
}

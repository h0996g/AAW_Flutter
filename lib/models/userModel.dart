class UserModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.phone,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['_id'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }
}

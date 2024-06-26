class UserModel {
  String? id;
  String? name;

  String? email;

  UserModel({
    this.id,
    this.name,
    this.email,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['_id'];
    email = json['email'];
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}

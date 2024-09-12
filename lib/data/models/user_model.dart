import 'package:maisevento/maisevento.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String name,
    required String email,
    required String password,
  }) : super(
          id: id,
          name: name,
          email: email,
          password: password,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}

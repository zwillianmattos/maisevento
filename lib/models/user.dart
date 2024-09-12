import 'package:mongo_dart/mongo_dart.dart';

class User {
  ObjectId? id;
  final String name;
  final String email;
  final String password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as ObjectId?,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}

import '../models/user_model.dart';
import '../../infrastructure/services/database_service.dart';
import 'package:maisevento/maisevento.dart';

abstract class UserDataSource {
  Future<UserModel?> getUserById(String id);
  Future<UserModel?> getUserByEmail(String email);
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String id);
}

class UserDataSourceImpl implements UserDataSource {
  final DatabaseService _databaseService;

  UserDataSourceImpl(this._databaseService);

  @override
  Future<UserModel?> getUserById(String id) async {
    final userData = await _databaseService.get('users', id);
    return userData.isNotEmpty ? UserModel.fromJson(userData) : null;
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    final userData = await _databaseService.getWhere('users', 'email', email);
    return userData.isNotEmpty ? UserModel.fromJson(userData) : null;
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    final createdUser = await _databaseService.create('users', user.toJson());
    return UserModel.fromJson(createdUser);
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    final updatedUser =
        await _databaseService.update('users', user.id, user.toJson());
    return UserModel.fromJson(updatedUser);
  }

  @override
  Future<void> deleteUser(String id) async {
    await _databaseService.delete('users', id);
  }
}

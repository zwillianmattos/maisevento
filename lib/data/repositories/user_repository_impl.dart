import 'package:bcrypt/bcrypt.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<User?> getUserById(String id) async {
    final userModel = await dataSource.getUserById(id);
    return userModel != null
        ? User(
            id: userModel.id,
            name: userModel.name,
            email: userModel.email,
            password: userModel.password,
          )
        : null;
  }

  @override
  Future<User> createUser(User user) async {
    String hashedPassword = BCrypt.hashpw(user.password, BCrypt.gensalt());
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: hashedPassword,
    );

    final createdUser = await dataSource.createUser(userModel);

    return User(
      id: createdUser.id,
      name: createdUser.name,
      email: createdUser.email,
      password: createdUser.password,
    );
  }

  @override
  Future<User> updateUser(User user) async {
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
    );
    final updatedUser = await dataSource.updateUser(userModel);
    return User(
      id: updatedUser.id,
      name: updatedUser.name,
      email: updatedUser.email,
      password: updatedUser.password,
    );
  }

  @override
  Future<void> deleteUser(String id) async {
    await dataSource.deleteUser(id);
  }

  @override
  Future<User?> checkCredentials(String email, String password) async {
    final userModel = await dataSource.getUserByEmail(email);
    if (userModel != null && BCrypt.checkpw(password, userModel.password)) {
      return userModel != null
          ? User(
              id: userModel.id,
              name: userModel.name,
              email: userModel.email,
              password: userModel.password,
            )
          : null;
    }
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final userModel = await dataSource.getUserByEmail(email);
    return userModel != null
        ? User(
            id: userModel.id,
            name: userModel.name,
            email: userModel.email,
            password: userModel.password,
          )
        : null;
  }
}

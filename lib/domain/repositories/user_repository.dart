import '../entities/user.dart';

abstract class UserRepository {
  Future<User?> getUserById(String id);
  Future<User?> getUserByEmail(String email);
  Future<User> createUser(User user);
  Future<User> updateUser(User user);
  Future<void> deleteUser(String id);
  Future<User?> checkCredentials(String email, String password);
}

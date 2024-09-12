import 'package:lucid_validation/lucid_validation.dart';
import 'package:maisevento/models/user.dart';
import 'package:maisevento/services/database_service.dart';
import 'package:maisevento/exceptions.dart';
import 'package:maisevento/validators/user_validator.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:maisevento/services/jwt_service.dart';

class AuthService {
  final DatabaseService _databaseService = DatabaseService();
  final UserValidator _userValidator = UserValidator();
  final JwtService _jwtService = JwtService();

  Future<void> register(User user) async {
    final validationResult = _userValidator.validate(user);

    if (!validationResult.isValid) {
      throw InvalidUserException(
          message: validationResult.exceptions
              .map((e) => e.message)
              .toList()
              .join(', '));
    }

    // Check if user already exists
    final existingUser = await _databaseService.getUserByEmail(user.email);
    if (existingUser != null) {
      throw UserAlreadyExistsException(
          message: 'A user with this email already exists');
    }

    // Hash the password
    String hashedPassword = BCrypt.hashpw(user.password, BCrypt.gensalt());

    // Create a new user with the hashed password
    User userToInsert = User(
      id: user.id,
      name: user.name,
      email: user.email,
      password: hashedPassword,
    );

    // Insert user into the database
    await _databaseService.insertUser(userToInsert);
  }

  // You might want to add a login method here
  Future<Map<String, String>?> login(String email, String password) async {
    final user = await _databaseService.getUserByEmail(email);
    if (user != null && BCrypt.checkpw(password, user.password)) {
      final accessToken = _jwtService.generateAccessToken(user.id.toString());
      final refreshToken = _jwtService.generateRefreshToken(user.id.toString());
      return {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
    }
    return null;
  }

  String? verifyToken(String token) {
    return _jwtService.verifyToken(token);
  }
}

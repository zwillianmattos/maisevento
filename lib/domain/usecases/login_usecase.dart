import '../repositories/user_repository.dart';
import '../../infrastructure/services/jwt_service.dart';
import '../../core/errors/failures.dart';

class LoginUseCase {
  final UserRepository userRepository;
  final JwtService jwtService;

  LoginUseCase(this.userRepository, this.jwtService);

  Future<Map<String, String>> execute(String email, String password) async {
    final user = await userRepository.checkCredentials(email, password);
    if (user == null) {
      throw AuthenticationFailure('Invalid email or password');
    }

    final accessToken = jwtService.generateToken(user.id);
    final refreshToken = jwtService.generateToken(user.id);

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

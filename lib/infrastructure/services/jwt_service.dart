import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';

abstract class JwtService {
  String generateToken(String userId);
  String? validateToken(String token);
}

class JwtServiceImpl implements JwtService {
  late DotEnv env;
  late final String _secretKey;
  JwtServiceImpl() {
    env = DotEnv(includePlatformEnvironment: true)..load();
    _secretKey = env['JWT_SECRET_KEY'] ?? '';
  }
  @override
  String generateToken(String userId) {
    final jwt = JWT(
      {'id': userId},
      issuer: 'maisevento',
    );
    return jwt.sign(SecretKey(_secretKey), expiresIn: Duration(hours: 24));
  }

  @override
  String? validateToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(_secretKey));
      return jwt.payload['id'] as String?;
    } on JWTExpiredException {
      print('JWT expired');
    } on JWTException catch (error) {
      print(error.message);
    }
    return null;
  }
}

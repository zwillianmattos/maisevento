import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'dart:math';

class JwtService {
  static const String _secret =
      'your_secret_key_here'; // Replace with a secure secret key
  static const String _issuer = 'maisevento_api';
  static const int _accessTokenExpirationMinutes = 15;
  static const int _refreshTokenExpirationDays = 7;

  String generateAccessToken(String userId) {
    final claimSet = JwtClaim(
      issuer: _issuer,
      subject: userId,
      expiry:
          DateTime.now().add(Duration(minutes: _accessTokenExpirationMinutes)),
      issuedAt: DateTime.now(),
    );
    return issueJwtHS256(claimSet, _secret);
  }

  String generateRefreshToken(String userId) {
    final claimSet = JwtClaim(
      issuer: _issuer,
      subject: userId,
      expiry: DateTime.now().add(Duration(days: _refreshTokenExpirationDays)),
      issuedAt: DateTime.now(),
      jwtId: _generateRandomString(16),
    );
    return issueJwtHS256(claimSet, _secret);
  }

  String? verifyToken(String token) {
    try {
      final decClaimSet = verifyJwtHS256Signature(token, _secret);
      decClaimSet.validate(issuer: _issuer);
      return decClaimSet.subject;
    } catch (e) {
      return null;
    }
  }

  String _generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}

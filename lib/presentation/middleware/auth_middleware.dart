import 'package:shelf/shelf.dart';
import '../../infrastructure/services/jwt_service.dart';

Middleware authMiddleware(JwtService jwtService) {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['Authorization'];
      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        final token = authHeader.substring(7);
        final userId = jwtService.validateToken(token);
        if (userId != null) {
          final updatedRequest = request.change(context: {'userId': userId});
          return await innerHandler(updatedRequest);
        }
      }
      return Response.unauthorized('Invalid token');
    };
  };
}

import 'dart:convert';
import 'package:maisevento/exceptions.dart';
import 'package:maisevento/services/jwt_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:maisevento/models/user.dart';
import 'package:maisevento/models/event.dart';
import 'package:maisevento/services/auth_service.dart';
import 'package:maisevento/services/event_service.dart';

class Service {
  final AuthService _authService = AuthService();
  final EventService _eventService = EventService();
  final JwtService _jwtService = JwtService();

  Handler get handler {
    final router = Router();

    router.post('/register', (Request request) async {
      try {
        final body = await request.readAsString();
        Map<String, dynamic> userMap = json.decode(body);
        final user = User.fromJson(userMap);

        await _authService.register(user);

        return Response.ok('User registered successfully',
            headers: {'Content-Type': 'application/json'});
      } on BaseException catch (e) {
        return Response.badRequest(
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'error': e.message,
            }));
      } on Exception catch (e) {
        return Response.internalServerError(
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'error': e.toString(),
            }));
      }
    });

    router.post('/login', (Request request) async {
      try {
        final body = await request.readAsString();
        final Map<String, dynamic> credentials = json.decode(body);
        final tokens = await _authService.login(
            credentials['email'], credentials['password']);
        if (tokens != null) {
          return Response.ok(json.encode(tokens),
              headers: {'Content-Type': 'application/json'});
        } else {
          return Response.unauthorized('Invalid credentials');
        }
      } catch (e) {
        return Response.internalServerError(
            body: json.encode({'error': e.toString()}),
            headers: {'Content-Type': 'application/json'});
      }
    });

    router.post('/refresh', (Request request) async {
      try {
        final body = await request.readAsString();
        final Map<String, dynamic> tokens = json.decode(body);
        final refreshToken = tokens['refreshToken'];
        final isValid = _jwtService.verifyToken(refreshToken);
        if (isValid == null) {
          return Response.unauthorized('Invalid refresh token');
        }

        final newRefreshToken = _jwtService.generateRefreshToken(isValid);
        final newAccessToken = _jwtService.generateAccessToken(isValid);
        return Response.ok(
            json.encode({
              'accessToken': newAccessToken,
              'refreshToken': newRefreshToken,
            }),
            headers: {'Content-Type': 'application/json'});
      } catch (e) {
        return Response.internalServerError(
            body: json.encode({'error': e.toString()}),
            headers: {'Content-Type': 'application/json'});
      }
    });

    router.post('/event', (Request request) async {
      try {
        final authHeader = request.headers['Authorization'];
        if (authHeader == null || !authHeader.startsWith('Bearer ')) {
          return Response.unauthorized(
              'Missing or invalid Authorization header');
        }
        final token = authHeader.substring(7);

        final body = await request.readAsString();
        final event = Event.fromJson(json.decode(body));
        await _eventService.createEvent(event, token);
        return Response.ok('Event created successfully',
            headers: {'Content-Type': 'application/json'});
      } on UnauthorizedException catch (e) {
        return Response.unauthorized(json.encode({'error': e.message}),
            headers: {'Content-Type': 'application/json'});
      } on BaseException catch (e) {
        return Response.badRequest(
            body: json.encode({'error': e.message}),
            headers: {'Content-Type': 'application/json'});
      } on Exception catch (e) {
        return Response.internalServerError(
            body: json.encode({'error': e.toString()}),
            headers: {'Content-Type': 'application/json'});
      }
    });

    router.get('/event', (Request request) async {
      try {
        final events = await _eventService.getAllEvents();
        return Response.ok(json.encode(events),
            headers: {'Content-Type': 'application/json'});
      } on Exception catch (e) {
        return Response.internalServerError(
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'error': e.toString()}));
      }
    });

    return router;
  }
}

void main(List<String> arguments) async {
  final service = Service();
  final server = await shelf_io.serve(service.handler, 'localhost', 8080);
  print('Server running on localhost:${server.port}');
}

import '../../domain/entities/user.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/get_user_by_email_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';
import '../../core/errors/failures.dart';

class UserController {
  final CreateUserUseCase createUserUseCase;
  final LoginUseCase loginUseCase;
  final GetUserByEmailUseCase getUserByEmailUseCase;

  UserController(
    this.createUserUseCase,
    this.loginUseCase,
    this.getUserByEmailUseCase,
  );

  Future<Response> createUser(Request request) async {
    try {
      final payload = await request.readAsString();
      final Map<String, dynamic> userData = json.decode(payload);

      final user = User(
        id: '', // O id será gerado pelo banco de dados
        name: userData['name'],
        email: userData['email'],
        password: userData['password'],
      );
      // Check if user already exists
      final userExists = await getUserByEmailUseCase.execute(user.email);
      if (userExists != null) {
        return Response.badRequest(
          body: json.encode({'error': 'User already exists'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      final createdUser = await createUserUseCase.execute(user);

      return Response.ok(
        json.encode({
          'name': createdUser.name,
          'email': createdUser.email,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      if (e is ServerFailure) {
        return Response.internalServerError(
          body: json.encode({'error': e.message}),
          headers: {'Content-Type': 'application/json'},
        );
      } else if (e is AuthenticationFailure) {
        return Response.unauthorized(json.encode({'error': e.message}));
      } else {
        return Response.internalServerError(
          body: json.encode({'error': 'An unexpected error occurred'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    }
  }

  Future<Response> login(Request request) async {
    try {
      final payload = await request.readAsString();
      final Map<String, dynamic> credentials = json.decode(payload);
      final tokens = await loginUseCase.execute(
        credentials['email'],
        credentials['password'],
      );
      return Response.ok(
        json.encode(tokens),
        headers: {'Content-Type': 'application/json'},
      );
    } on AuthenticationFailure catch (e) {
      return Response.unauthorized(
        json.encode({'error': e.message}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}

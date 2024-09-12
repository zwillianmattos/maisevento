import 'package:dotenv/dotenv.dart';
import 'package:maisevento/presentation/middleware/auth_middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:maisevento/maisevento.dart';

void main() async {
  // Carrega as variáveis de ambiente
  var env = DotEnv(includePlatformEnvironment: true)..load();

  await setupDependencies();

  final userController = getIt<UserController>();
  final eventController = getIt<EventController>();
  final jwtService = getIt<JwtService>();

  final authHandler = Pipeline()
      .addMiddleware(authMiddleware(jwtService))
      .addHandler((Request request) {
    if (request.url.path == 'events' && request.method == 'POST') {
      return eventController.createEvent(request);
    } else if (request.url.path == 'events' && request.method == 'GET') {
      return eventController.getAllEvents(request);
    }
    return Response.notFound('Not Found');
  });

  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler((Request request) {
    if (request.url.path == 'login' && request.method == 'POST') {
      return userController.login(request);
    } else if (request.url.path == 'register' && request.method == 'POST') {
      return userController.createUser(request);
    }
    return authHandler(request);
  });

  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}

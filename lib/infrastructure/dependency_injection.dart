import 'package:get_it/get_it.dart';
import '../data/datasources/user_datasource.dart';
import '../data/datasources/event_datasource.dart';
import '../data/repositories/user_repository_impl.dart';
import '../data/repositories/event_repository_impl.dart';
import 'package:maisevento/maisevento.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Database
  final databaseService = DatabaseServiceImpl();
  await databaseService.connect();
  getIt.registerSingleton<DatabaseService>(databaseService);

  // Services
  getIt.registerLazySingleton<JwtService>(() => JwtServiceImpl());

  // Data sources
  getIt.registerLazySingleton<UserDataSource>(
      () => UserDataSourceImpl(getIt<DatabaseService>()));
  getIt.registerLazySingleton<EventDataSource>(
      () => EventDataSourceImpl(getIt<DatabaseService>()));

  // Repositories
  getIt.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(getIt<UserDataSource>()));
  getIt.registerLazySingleton<EventRepository>(
      () => EventRepositoryImpl(getIt<EventDataSource>()) as EventRepository);

  // Validators
  getIt.registerLazySingleton(() => UserValidator());
  getIt.registerLazySingleton(() => EventValidator());

  // Use cases
  getIt.registerLazySingleton(
      () => CreateUserUseCase(getIt<UserRepository>(), getIt<UserValidator>()));
  getIt.registerLazySingleton(() =>
      CreateEventUseCase(getIt<EventRepository>(), getIt<EventValidator>()));
  getIt.registerLazySingleton(
      () => GetUserByEmailUseCase(getIt<UserRepository>()));
  getIt
      .registerLazySingleton(() => GetUserByIdUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton(
      () => GetAllEventsUseCase(getIt<EventRepository>()));
  getIt.registerLazySingleton(
      () => LoginUseCase(getIt<UserRepository>(), getIt()));

  // Controllers
  getIt.registerLazySingleton(() => UserController(
        getIt<CreateUserUseCase>(),
        getIt<LoginUseCase>(),
        getIt<GetUserByEmailUseCase>(),
      ));

  getIt.registerLazySingleton(() => EventController(
        getIt<CreateEventUseCase>(),
        getIt<GetAllEventsUseCase>(),
      ));
}

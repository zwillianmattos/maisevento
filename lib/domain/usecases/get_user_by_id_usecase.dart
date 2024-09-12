import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserByIdUseCase {
  final UserRepository userRepository;

  GetUserByIdUseCase(this.userRepository);

  Future<User?> execute(String id) async {
    return await userRepository.getUserById(id);
  }
}

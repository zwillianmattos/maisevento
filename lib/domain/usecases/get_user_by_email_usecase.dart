import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserByEmailUseCase {
  final UserRepository userRepository;

  GetUserByEmailUseCase(this.userRepository);

  Future<User?> execute(String email) async {
    return await userRepository.getUserByEmail(email);
  }
}

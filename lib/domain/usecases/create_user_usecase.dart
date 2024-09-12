import 'package:maisevento/core/errors/failures.dart';

import '../entities/user.dart';
import '../repositories/user_repository.dart';
import '../../validators/user_validator.dart';

class CreateUserUseCase {
  final UserRepository userRepository;
  final UserValidator userValidator;

  CreateUserUseCase(this.userRepository, this.userValidator);

  Future<User> execute(User user) async {
    final validationResult = userValidator.validate(user);
    if (!validationResult.isValid) {
      throw ServerFailure(
          validationResult.exceptions.map((e) => e.message).join(', '));
    }
    return await userRepository.createUser(user);
  }
}

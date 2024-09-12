import 'package:lucid_validation/lucid_validation.dart';
import '../models/user.dart';

class UserValidator extends LucidValidator<User> {
  UserValidator() {
    ruleFor((user) => user.name, key: 'name')
        .notEmpty()
        .maxLength(50, message: 'O nome deve ter no máximo 50 caracteres');

    ruleFor((user) => user.email, key: 'email').notEmpty().validEmail();

    ruleFor((user) => user.password, key: 'password')
        .notEmpty()
        .minLength(8, message: 'Must be at least 8 characters long')
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveSpecialCharacter();
  }
}

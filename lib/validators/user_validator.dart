import 'package:lucid_validation/lucid_validation.dart';
import '../domain/entities/user.dart';

class UserValidator extends LucidValidator<User> {
  UserValidator() {
    ruleFor((user) => user.name, key: 'name')
        .notEmpty()
        .minLength(3)
        .maxLength(50);

    ruleFor((user) => user.email, key: 'email').notEmpty().validEmail();

    ruleFor((user) => user.password, key: 'password')
        .notEmpty()
        .minLength(8)
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveSpecialCharacter();
  }
}

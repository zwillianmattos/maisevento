import 'package:lucid_validation/lucid_validation.dart';
import '../models/event.dart';

class EventValidator extends LucidValidator<Event> {
  EventValidator() {
    ruleFor((event) => event.name, key: 'name')
        .notEmpty()
        .maxLength(100, message: 'O título deve ter no máximo 100 caracteres');

    ruleFor((event) => event.description, key: 'description')
        .notEmpty()
        .maxLength(500,
            message: 'A descrição deve ter no máximo 500 caracteres');

    ruleFor((event) => event.date, key: 'date').greaterThan(DateTime.now(),
        message: 'A data do evento deve ser no futuro');

    ruleFor((event) => event.location, key: 'location').notEmpty();

    ruleFor((event) => event.capacity, key: 'capacity')
        .greaterThan(0, message: 'A capacidade deve ser maior que zero');

    ruleFor((event) => event.activities, key: 'activities').must(
        (activities) => activities.isNotEmpty,
        'Atividades não podem ser vazias',
        'activities');
  }
}

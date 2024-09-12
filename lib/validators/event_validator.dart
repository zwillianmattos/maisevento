import 'package:lucid_validation/lucid_validation.dart';
import '../domain/entities/event.dart';

class EventValidator extends LucidValidator<Event> {
  EventValidator() {
    ruleFor((event) => event.title, key: 'title')
        .notEmpty()
        .minLength(3)
        .maxLength(100);

    ruleFor((event) => event.description, key: 'description')
        .notEmpty()
        .maxLength(500);

    ruleFor((event) => event.date, key: 'date').must(
        (date) => date.isAfter(DateTime.now()),
        'Date must be in the future',
        'date');

    ruleFor((event) => event.location, key: 'location')
        .notEmpty()
        .maxLength(200);
  }
}

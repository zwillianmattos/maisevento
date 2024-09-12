import '../entities/event.dart';
import '../repositories/event_repository.dart';
import '../../validators/event_validator.dart';
import '../../core/errors/failures.dart';

class CreateEventUseCase {
  final EventRepository eventRepository;
  final EventValidator eventValidator;

  CreateEventUseCase(this.eventRepository, this.eventValidator);

  Future<Event> execute(Event event) async {
    final validationResult = eventValidator.validate(event);
    if (!validationResult.isValid) {
      throw ValidationFailure(
          validationResult.exceptions.map((e) => e.message).join(', '));
    }
    return await eventRepository.createEvent(event);
  }
}

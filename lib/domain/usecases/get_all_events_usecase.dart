import 'package:maisevento/maisevento.dart';

class GetAllEventsUseCase {
  final EventRepository eventRepository;

  GetAllEventsUseCase(this.eventRepository);

  Future<List<Event>> execute() async {
    return await eventRepository.getAllEvents();
  }
}

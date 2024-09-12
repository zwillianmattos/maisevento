class BaseException implements Exception {
  final String message;
  BaseException({required this.message});
}

class UserAlreadyExistsException extends BaseException {
  UserAlreadyExistsException({required String message})
      : super(message: message);
}

class InvalidUserException extends BaseException {
  InvalidUserException({required dynamic message}) : super(message: message);
}

class EventCreationException extends BaseException {
  EventCreationException({required String message}) : super(message: message);
}

class EventFetchException extends BaseException {
  EventFetchException({required String message}) : super(message: message);
}

class EventUpdateException extends BaseException {
  EventUpdateException({required String message}) : super(message: message);
}

class EventDeletionException extends BaseException {
  EventDeletionException({required String message}) : super(message: message);
}

class UnauthorizedException extends BaseException {
  UnauthorizedException({required String message}) : super(message: message);
}

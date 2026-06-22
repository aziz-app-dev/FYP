// ignore_for_file: prefer_typing_uninitialized_variables, strict_top_level_inference
class AppException implements Exception {
  final String? message;
  final String? prefix;

  AppException([this.message, this.prefix]);

  @override
  String toString() {
    if (message != null && message!.isNotEmpty) return message!;
    return prefix ?? 'An error occurred';
  }
}

class NoInternetException extends AppException {
  NoInternetException([String? message]) : super(message, "No Internet");
}

class UnathorizedException extends AppException {
  UnathorizedException([String? message])
    : super(message, "You don't have access to this");
}

class RequestTimeOutException extends AppException {
  RequestTimeOutException([String? message])
    : super(message, "Request Time-out");
}

class BadRequestException extends AppException {
  BadRequestException([String? message])
    : super(message, "Something went wrong");
}

class FetchDataException extends AppException {
  FetchDataException([String message = 'Unable to fetch data'])
    : super(message, 'Fetch Error');
}

class ServerException extends AppException {
  ServerException([String message = 'Internal server error'])
    : super(message, 'Server Error');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String message = 'You are not authorized'])
    : super(message, 'Unauthorized');
}

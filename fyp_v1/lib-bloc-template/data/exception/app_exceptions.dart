// ignore_for_file: strict_top_level_inference, prefer_typing_uninitialized_variables

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() => '$_message$_prefix';
}

/// Exception class representing a fetch data error during communication.
class FetchDataException extends AppException {
  FetchDataException([String? message])
    : super(message, 'Error During Communication');
}

/// Exception class representing a bad request error.
class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, 'Invalid request');
}

/// Exception class representing an unauthorized request error.
class UnauthorisedException extends AppException {
  UnauthorisedException([String? message])
    : super(message, 'Unauthorised request');
}

/// Exception class representing an invalid input error.
class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, 'Invalid Input');
}

class NoInternetException extends AppException {
  NoInternetException([String? message])
    : super(message, 'No Internet Connection');
}

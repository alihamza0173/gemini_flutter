class AppException implements Exception {
  String? _message, _prefix;

  AppException(this._message, this._prefix);

  @override
  String toString() {
    return '$_message$_prefix';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, 'Error During Communication');
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, 'Invalid request');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message])
      : super(message, 'Unauthorized request');
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, 'Invalid Input');
}

class NoInternetException extends AppException {
  NoInternetException([String? message])
      : super(message, 'No Internet Connection');
}

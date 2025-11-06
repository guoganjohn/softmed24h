class AppException implements Exception {
  final String? message;
  final String? prefix;
  final int? statusCode;

  AppException([this.message, this.prefix, this.statusCode]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message, int? statusCode])
    : super(message, "Error During Communication: ", statusCode);
}

class BadRequestException extends AppException {
  BadRequestException([String? message, int? statusCode])
    : super(message, "Invalid Request: ", statusCode);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message, int? statusCode])
    : super(message, "Unauthorized: ", statusCode);
}

class ForbiddenException extends AppException {
  ForbiddenException([String? message, int? statusCode])
    : super(message, "Forbidden: ", statusCode);
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message, int? statusCode])
    : super(message, "Invalid Input: ", statusCode);
}

class NotFoundException extends AppException {
  NotFoundException([String? message, int? statusCode])
    : super(message, "Not Found: ", statusCode);
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException([String? message, int? statusCode])
    : super(message, "Internal Server Error: ", statusCode);
}

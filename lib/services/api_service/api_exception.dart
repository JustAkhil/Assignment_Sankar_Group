class ApiException implements Exception {
  String msg;
  String title;

  ApiException({required this.title, required this.msg});

  @override
  String toString() {
    return 'ApiException(title: $title)';
  }
}
class FetchDataException extends ApiException {
  FetchDataException({required String msg})
      : super(title: "No Internet Connection", msg: msg);
}
class ServerException extends ApiException {
  ServerException({required String msg})
      : super(title: "Server Error", msg: msg);
}
class BadRequestException extends ApiException {
  BadRequestException({required String msg})
      : super(title: "Bad Request", msg: msg);
}
class UnauthorizedException extends ApiException {
  UnauthorizedException({required String msg})
      : super(title: "Unauthorized", msg: msg);
}
class NotFoundException extends ApiException {
  NotFoundException({required String msg})
      : super(title: "Not Found", msg: msg);
}


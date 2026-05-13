import 'dart:convert';
import 'dart:io';

import 'package:assignment_sankar_group/services/api_service/api_exception.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  Future<dynamic> getApi({required String url}) async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      return handleresponse(response: response);
    } on SocketException catch (e) {
      FetchDataException(msg: e.toString());
    }
  }
}

handleresponse({required http.Response response}) {
  switch (response.statusCode) {
    case 200:
      return jsonDecode(response.body);
    case 400:
      BadRequestException(msg: response.body.toString());
    case 401:
    case 403:
      UnauthorizedException(msg: response.body.toString());
    case 404:
      NotFoundException(msg: response.body.toString());
    default:
      FetchDataException(msg: response.body.toString());
  }
}

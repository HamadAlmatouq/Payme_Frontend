import 'package:dio/dio.dart';

class Client {
  static final Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 5000),
      baseUrl:
          'https://coded-pets-api-auth.eapi.joincoded.com')); //'https://coded-pets-api-auth.eapi.joincoded.com';
}

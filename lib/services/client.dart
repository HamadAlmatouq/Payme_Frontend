import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Client {
  static Dio dio = Dio(BaseOptions(
    // connectTimeout: Duration(milliseconds: 5000),
    // receiveTimeout: Duration(milliseconds: 5000),
    baseUrl: 'http://localhost:8000',
  ));
}

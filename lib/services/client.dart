import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Client {
  static Dio dio = Dio(BaseOptions(
    connectTimeout: Duration(milliseconds: 5000),
    receiveTimeout: Duration(milliseconds: 5000),
    baseUrl: 'http://localhost:8000',
  ));

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<Response> getBalance() async {
    final token = await getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      return await dio.get('/auth/balance',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
    } catch (e) {
      throw Exception('Unable to get balance: $e');
    }
  }
}

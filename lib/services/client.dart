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
    String? token = prefs.getString('auth_token');

    if (token == null) {
      print('No token found in SharedPreferences');
    } else {
      print('Token retrieved: $token');
    }

    return token;
  }

  static Future<Response> getBalance() async {
    final token = await getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      return await dio.get(
        '/auth/balance',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      throw Exception('Unable to get balance: $e');
    }
  }

  static Future<Response> lendMoney({
    required double amount,
    required String toUsername,
    required String endDate,
  }) async {
    final token = await getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      return await dio.post(
        '/loans',
        data: {
          "amount": amount,
          "endDate": endDate,
          "toUsername": toUsername,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      throw Exception('Unable to lend money: $e');
    }
  }
}

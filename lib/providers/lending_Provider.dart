import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/client.dart';

class LendingProvider with ChangeNotifier {

  // Token
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

  // Balance
  static Future<Response> getBalance() async {
    final token = await getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      return await Client.dio.get(
        '/auth/balance',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      throw Exception('Unable to get balance: $e');
    }
  }

  // Lending
  static Future<Response> lendMoney({
    required double amount,
    required String toUsername,
    required String installmentFrequency,
    required int duration

  }) async {
    final token = await getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      return await Client.dio.post(
        '/loans/add-loan',
        data: {
          "amount": amount,
          "installmentFrequency": installmentFrequency,
          "toUsername": toUsername,
          "duration": duration,
          
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


  


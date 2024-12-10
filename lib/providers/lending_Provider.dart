import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/client.dart';

class LendingProvider with ChangeNotifier {
  double _balance = 0.0;

  double get balance => _balance;

  Future<void> fetchBalance() async {
    try {
      Response response = await Client.dio.get('/auth/balance');

      if (response.statusCode == 200 && response.data is Map) {
        _balance = response.data['balance']?.toDouble() ?? 0.0;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching balance: $e');
      _balance = 0.0;
      notifyListeners();
    }
  }

  Future<void> lendMoney(double amount, String toUsername, String endDate, BuildContext context) async {
    final token = await Client.getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No token found. Please sign in again.')),
      );
      return;
    }

    print('Token being used for request: $token');

    try {
      Response response = await Client.dio.post(
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

      print('API Response: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        _balance -= amount;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Successfully lent $amount KWD to $toUsername")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to lend money')),
        );
      }
    } catch (e) {
      print('Request Error: ${Error}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while lending money')),
      );
    }
  }
}

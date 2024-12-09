import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:payme_frontend/services/client.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double balance = 0.0;
  String greeting = "Good Morning";
  String username = "Hussain";

  @override
  void initState() {
    super.initState();
    _getBalance();
  }

  Future<void> _getBalance() async {
    try {
      Response response = await Client.getBalance();

      if (response.statusCode == 200 && response.data is Map) {
        setState(() {
          balance = response.data['balance']?.toDouble() ?? 0.0;
        });
      } else {
        print('Failed to get balance: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching balance: $e');
      setState(() {
        balance = 0.0;
      });
    }
  }

  Future<void> _lendMoney(
      double amount, String toUsername, String endDate) async {
    if (amount > balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Insufficient balance to lend $amount KWD")),
      );
      return;
    }

    try {
      final token = await Client.getToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No token found. Please sign in again.")),
        );
        return;
      }

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          balance -= amount;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Successfully lent $amount KWD to $toUsername")),
        );
      } else {
        print('Failed to lend money: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Failed to lend money: ${response.data['message'] ?? 'Unknown error'}"),
          ),
        );
      }
    } catch (e) {
      print('Error lending money: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred while lending money")),
      );
    }
  }

  void _showLendMoneyDialog() {
    String toUsername = "";
    double amount = 0.0;
    String endDate = "2025-01-01";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Lend Money"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Recipient Username"),
                onChanged: (value) {
                  toUsername = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amount = double.tryParse(value) ?? 0.0;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "End Date (YYYY-MM-DD)"),
                onChanged: (value) {
                  endDate = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _lendMoney(amount, toUsername, endDate);
                Navigator.pop(context);
              },
              child: Text("Send"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: greeting,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: ", ",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: username,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      context.go('/notifications');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "$balance KWD",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _showLendMoneyDialog,
                      child: const Text("Lend Money"),
                    ),
                  ],
                ),
              ),
              // The rest of your UI remains unchanged
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:payme_frontend/providers/lending_provider.dart';
import 'package:payme_frontend/services/client.dart';
import 'package:payme_frontend/pages/loan_dialog.dart';
import 'package:payme_frontend/pages/payment_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double balance = 0.0;
  String greeting = "Good Morning";
  String username = "Hussain";

  final List<Map<String, dynamic>> contacts = [
    {"name": "Hamad", "image": "assets/images/1.png", "rating": 4.5},
    {"name": "Ghanim", "image": "assets/images/1.png", "rating": 3.8},
    {"name": "Yousef", "image": "assets/images/1.png", "rating": 4.0},
    {"name": "Reem", "image": "assets/images/1.png", "rating": 4.9},
    {"name": "Abdulwahab", "image": "assets/images/1.png", "rating": 2.0},
    {"name": "Meshari", "image": "assets/images/1.png", "rating": 3.7},
  ];

  final List<Map<String, dynamic>> upcomingPayments = [
    {"name": "Hamad", "amount": 25.0, "dueDate": "9 Dec 2024"},
    {"name": "Ghanim", "amount": 125.0, "dueDate": "10 Dec 2024"},
    {"name": "Yousef", "amount": 41.0, "dueDate": "11 Dec 2024"},
    {"name": "Reem", "amount": 75.0, "dueDate": "15 Dec 2024"},
  ];

  @override
  void initState() {
    super.initState();
    _getBalance();
  }

  Future<void> _getBalance() async {
    try {
      Response response = await LendingProvider.getBalance();

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
    double amount,
    String toUsername,
    String installmentFrequency,
    int duration,
  ) async {
    if (amount > balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Insufficient balance to lend $amount KWD")),
      );
      return;
    }

    try {
      final token = await LendingProvider.getToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No token found. Please sign in again.")),
        );
        return;
      }

      Response response = await Client.dio.post(
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
    String installmentFrequency = "";
    int duration = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
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
           // Dropdown to select Duration (1-12)
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: "Duration"),
                items: List.generate(12, (index) {
                  int number = index + 1;
                  return DropdownMenuItem<int>(
                    value: number,
                    child: Text('$number'),
                  );
                }),
                value: duration != 0 ? duration : null,
                onChanged: (newValue) {
                  setState(() {
                    duration = newValue!;
                  });
                },
              ),
                // Dropdown to select Installment Frequency
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Installment"),
                  items: ['daily', 'weekly', 'monthly'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: installmentFrequency.isNotEmpty
                      ? installmentFrequency
                      : null,
                  onChanged: (newValue) {
                    setState(() {
                      installmentFrequency = newValue!;
                    });
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
                  _lendMoney(amount, toUsername, installmentFrequency, duration);
                  Navigator.pop(context);
                },
                child: Text("Send"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showContactDialog(BuildContext context, Map<String, dynamic> contact) {
    // Implementation for showing a contact-specific dialog
  }

  void _showPaymentDialog(BuildContext context, String name, double amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PaymentDialog(name: name, amount: amount);
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
                    ElevatedButton(
                      onPressed: () {
                        print("Button");
                      },
                      child: const Text("Third Button"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Contacts",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          _showContactDialog(context, contact);
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(contact["image"]),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              contact["name"],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Upcoming Payments",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: upcomingPayments.length,
                  itemBuilder: (context, index) {
                    final payment = upcomingPayments[index];
                    final initial = payment["name"][0].toUpperCase();

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blueAccent,
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${payment["amount"]} KWD",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 54, 139, 244),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    payment["name"],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Due: ${payment["dueDate"]}",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 210, 113, 113),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showPaymentDialog(context, payment["name"],
                                    payment["amount"]);
                              },
                              child: const Text("Pay"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

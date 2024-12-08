import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payme_frontend/pages/loan_dialog.dart';
import 'package:payme_frontend/pages/payment_dialog.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  void _showPaymentDialog(BuildContext context, String name, double amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PaymentDialog(name: name, amount: amount);
      },
    );
  }

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

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  void _showLoanDialog(BuildContext context, String title, String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoanDialog(
          title: title,
          action: action,
          onSubmit: ({
            required double amount,
            required String contact,
            String? installments,
            String? duration,
            String? password,
          }) {
            print("Action: $action");
            print("Amount: $amount");
            print("Contact: $contact");
            print("Installments: $installments");
            print("Duration: $duration");
            print("Password: $password");
          },
        );
      },
    );
  }

  void _showContactDialog(BuildContext context, Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(contact["image"]),
              ),
              const SizedBox(width: 10),
              Text(contact["name"]),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  Text("${contact["rating"]}"),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showLoanDialog(
                        context,
                        "Borrow from ${contact["name"]}",
                        "Borrow",
                      );
                    },
                    child: const Text("Borrow"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showLoanDialog(
                        context,
                        "Lend to ${contact["name"]}",
                        "Lend",
                      );
                    },
                    child: const Text("Lend"),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String greeting = getGreeting();
    String username = "Hussain";
    double balance = 1228.0;

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
                  Text(
                    "$greeting, $username",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showLoanDialog(context, "Borrow Money", "Borrow");
                          },
                          child: const Text("Borrow"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            _showLoanDialog(context, "Lend Money", "Lend");
                          },
                          child: const Text("Lend"),
                        ),
                      ],
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
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            payment["name"][0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          "${payment["amount"]} KWD",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        subtitle: Text(
                          "Due: ${payment["dueDate"]}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _showPaymentDialog(
                                context, payment["name"], payment["amount"]);
                          },
                          child: const Text("Pay"),
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

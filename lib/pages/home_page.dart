import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:payme_frontend/providers/lending_provider.dart';
import 'package:payme_frontend/services/client.dart';
import 'package:payme_frontend/pages/payment_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double balance = 0.0;
  String greeting = "Good Morning";
  String username = "";
  List<Map<String, dynamic>> upcomingPayments = [];

  final List<Map<String, dynamic>> contacts = [
    {"name": "Hamad", "image": "assets/images/1.png", "rating": 4.5},
    {"name": "Ghanim", "image": "assets/images/1.png", "rating": 3.8},
    {"name": "Yousef", "image": "assets/images/1.png", "rating": 4.0},
    {"name": "Reem", "image": "assets/images/1.png", "rating": 4.9},
    {"name": "Abdulwahab", "image": "assets/images/1.png", "rating": 2.0},
    {"name": "Meshari", "image": "assets/images/1.png", "rating": 3.7},
  ];

  @override
  void initState() {
    super.initState();
    _getBalance();
    _fetchDebts();
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

  Future<void> _fetchDebts() async {
    try {
      Response response = await LendingProvider.fetchDebts();

      if (response.statusCode == 200 && response.data is Map) {
        setState(() {
          upcomingPayments =
              List<Map<String, dynamic>>.from(response.data['debts']);
        });
      } else {
        print('Failed to fetch debts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching debts: $e');
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
      Response response = await LendingProvider.lendMoney(
        amount: amount,
        toUsername: toUsername,
        installmentFrequency: installmentFrequency,
        duration: duration,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          balance -= amount;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Successfully lent $amount KWD to $toUsername")),
        );

        _fetchDebts();
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

  Future<void> _repayLoan(String loanId, double amount) async {
    try {
      Response response = await LendingProvider.repayLoan(
        loanId: loanId,
        amount: amount,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Successfully repaid $amount KWD")),
        );
        _fetchDebts();
      } else {
        print('Failed to repay loan: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Failed to repay loan: ${response.data['message'] ?? 'Unknown error'}"),
          ),
        );
      }
    } catch (e) {
      print('Error repaying loan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred while repaying loan")),
      );
    }
  }

  void _showLendMoneyDialog({String? prefilledUsername}) {
    TextEditingController usernameController =
        TextEditingController(text: prefilledUsername ?? "");
    double amount = 0.0;
    String installmentFrequency = "";
    int duration = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Lend Money"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration:
                    const InputDecoration(labelText: "Recipient Username"),
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amount = double.tryParse(value) ?? 0.0;
                },
              ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: "Duration"),
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Installment"),
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
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _lendMoney(
                  amount,
                  usernameController.text,
                  installmentFrequency,
                  duration,
                );
                Navigator.pop(context);
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: [
        ...List.generate(fullStars, (index) {
          return const Icon(Icons.star, color: Colors.amber, size: 14);
        }),
        if (halfStar)
          const Icon(Icons.star_half, color: Colors.amber, size: 14),
        if (fullStars < 5 && !halfStar)
          ...List.generate(5 - fullStars, (index) {
            return const Icon(Icons.star_border, color: Colors.amber, size: 14);
          }),
      ],
    );
  }

  void _showContactDialog(BuildContext context, Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = contact["rating"];
        String comment;

        //Ratings
        if (rating >= 4.5) {
          comment = "Trustworthy, always pays on time.";
        } else if (rating >= 4.0) {
          comment = "Great, reliable lender.";
        } else if (rating >= 3.0) {
          comment = "Good, but proceed with caution.";
        } else {
          comment = "Risky, be careful.";
        }

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Back Arrow
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                //Profile Picture
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(contact["image"]),
                ),
                const SizedBox(height: 10),
                //Name
                Text(
                  contact["name"],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                //Star Ratings
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    if (index < rating.floor()) {
                      return const Icon(Icons.star,
                          color: Colors.amber, size: 20);
                    } else if (index < rating) {
                      return const Icon(Icons.star_half,
                          color: Colors.amber, size: 20);
                    } else {
                      return const Icon(Icons.star_border,
                          color: Colors.amber, size: 20);
                    }
                  }),
                ),
                const SizedBox(height: 10),

                Text(
                  comment,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),
                // Buttons: Lend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Lend logic
                        _showLendMoneyDialog(
                            prefilledUsername: contact["name"]);
                      },
                      child: const Text("Lend"),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Balance",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "$balance KWD",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _showLendMoneyDialog(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Lend",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
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
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showContactDialog(context, contact);
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(contact["image"]),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            contact["name"],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
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
                    final initial =
                        payment["fromAccount"]["username"][0].toUpperCase();
                    final duration =
                        payment["duration"] ?? 1; // Provide a default value
                    final installmentFrequency =
                        payment["installmentFrequency"] ?? 'weekly';
                    double installmentAmount;

                    if (installmentFrequency == 'daily') {
                      installmentAmount =
                          payment["amount"].toDouble() / (duration * 30);
                    } else if (installmentFrequency == 'weekly') {
                      installmentAmount =
                          payment["amount"].toDouble() / (duration * 4);
                    } else {
                      installmentAmount =
                          payment["amount"].toDouble() / duration;
                    }

                    final remainingAmount =
                        payment["remainingAmount"].toDouble();

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
                                    payment["fromAccount"]["username"],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Remaining: $remainingAmount KWD",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _repayLoan(
                                    payment["loanId"], installmentAmount);
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

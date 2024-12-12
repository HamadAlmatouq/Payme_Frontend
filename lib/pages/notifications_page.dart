import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payme_frontend/services/client.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token not found');
      }

      Response response = await Client.dio.get(
        '/loans/transactions',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data is Map) {
        setState(() {
          transactions =
              List<Map<String, dynamic>>.from(response.data['transactions']);
          isLoading = false;
        });
      } else {
        print('Failed to fetch transactions: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height:
            MediaQuery.of(context).size.height, // Ensures full-screen height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context.go('/home');
                        },
                      ),
                      const Text(
                        "Notifications",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 48), // To balance the row
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Body Content
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return Card(
                              color: Colors.white
                                  .withOpacity(0.85), // Semi-transparent card
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Username: ${transaction['fromAccount']['contact']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF003366),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'From: ${transaction['fromAccount']['contact']}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'To: ${transaction['toAccount']['contact']}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'Amount: ${transaction['amount']} KWD',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Start Date: ${transaction['startDate']}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'Duration: ${transaction['duration']} months',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'Installment Frequency: ${transaction['installmentFrequency']}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'Remaining Amount: ${transaction['remainingAmount']} KWD',
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
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
      ),
    );
  }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             context.go('/home');
//           },
//         ),
//         title: const Text(
//           "Notifications",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor:
//             const Color(0xFF6699CC), // Lighter shade for the AppBar
//         elevation: 0, // Flat design
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFB3D1FF), Color(0xFFDDEEFF)], // Lighter gradient
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6699CC)),
//                 ),
//               )
//             : ListView.builder(
//                 itemCount: transactions.length,
//                 itemBuilder: (context, index) {
//                   final transaction = transactions[index];
//                   return Card(
//                     color: Colors.white
//                         .withOpacity(0.95), // Lighter card background
//                     margin:
//                         const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Username: ${transaction['fromAccount']['contact']}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF003366),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'From: ${transaction['fromAccount']['contact']}',
//                             style: const TextStyle(color: Colors.black54),
//                           ),
//                           Text(
//                             'To: ${transaction['toAccount']['contact']}',
//                             style: const TextStyle(color: Colors.black54),
//                           ),
//                           Text(
//                             'Amount: ${transaction['amount']} KWD',
//                             style: const TextStyle(color: Colors.black),
//                           ),
//                           Text(
//                             'Start Date: ${transaction['startDate']}',
//                             style: const TextStyle(color: Colors.black54),
//                           ),
//                           Text(
//                             'Duration: ${transaction['duration']} months',
//                             style: const TextStyle(color: Colors.black54),
//                           ),
//                           Text(
//                             'Installment Frequency: ${transaction['installmentFrequency']}',
//                             style: const TextStyle(color: Colors.black54),
//                           ),
//                           Text(
//                             'Remaining Amount: ${transaction['remainingAmount']} KWD',
//                             style: const TextStyle(color: Colors.red),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             context.go('/home');
//           },
//         ),
//         title: const Text("Notifications"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: transactions.length,
//               itemBuilder: (context, index) {
//                 final transaction = transactions[index];
//                 return Card(
//                   margin:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Username: ${transaction['fromAccount']['contact']}',
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 8),
//                         Text('From: ${transaction['fromAccount']['contact']}'),
//                         Text('To: ${transaction['toAccount']['contact']}'),
//                         Text('Amount: ${transaction['amount']} KWD'),
//                         Text('Start Date: ${transaction['startDate']}'),
//                         Text('Duration: ${transaction['duration']} months'),
//                         Text(
//                             'Installment Frequency: ${transaction['installmentFrequency']}'),
//                         Text(
//                             'Remaining Amount: ${transaction['remainingAmount']} KWD'),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
}

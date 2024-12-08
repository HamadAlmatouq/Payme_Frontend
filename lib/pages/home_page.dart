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
            // Handle the submitted data
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
                "Upcoming Payments",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                        _showPaymentDialog(context, payment["name"], payment["amount"]);
                      },
                      child: const Text("Pay"),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:payme_frontend/pages/loan_dialog.dart';

// class HomePage extends StatelessWidget {
//   HomePage({Key? key}) : super(key: key);

//   // List of upcoming payments
//   final List<Map<String, dynamic>> upcomingPayments = [
//     {"name": "Hamad", "amount": 25, "dueDate": "9 Dec 2024"},
//     {"name": "Ghanim", "amount": 125, "dueDate": "10 Dec 2024"},
//     {"name": "Yousef", "amount": 41, "dueDate": "11 Dec 2024"},
//     {"name": "Reem", "amount": 75, "dueDate": "15 Dec 2024"},
//   ];

//   // Other methods and the build method remain the same

  

//   void _showLoanDialog(BuildContext context, String title, String action) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return LoanDialog(
//           title: title,
//           action: action,
//           onSubmit: ({
//             required double amount,
//             required String contact,
//             String? installments,
//             String? duration,
//             String? password,
//           }) {
//             // Handle the submitted data
//             print("Action: $action");
//             print("Amount: $amount");
//             print("Contact: $contact");
//             print("Installments: $installments");
//             print("Duration: $duration");
//             print("Password: $password");
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     String greeting = "Good Morning";
//     String username = "Hussain";
//     double balance = 1228.0;

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("$greeting, $username",
//                     style: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold)),
//                 IconButton(
//                     icon: const Icon(Icons.notifications),
//                     onPressed: () {
//                       // Navigate to Notifications Page
//                       context.go('/notifications');
//                     },
//                   ),
//                 // IconButton(
//                 //   icon: const Icon(Icons.notifications),
//                 //   onPressed: () {
//                 //     print("Notifications clicked!");
//                 //   },
//                 // ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.blueAccent.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("$balance KWD",
//                       style: const TextStyle(
//                           fontSize: 28, fontWeight: FontWeight.bold)),
//                   Row(
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           _showLoanDialog(context, "Borrow Money", "Borrow");
//                         },
//                         child: const Text("Borrow"),
//                       ),
//                       const SizedBox(width: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           _showLoanDialog(context, "Lend Money", "Lend");
//                         },
//                         child: const Text("Lend"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // // import 'dart:ui';
// // // import 'package:flutter/material.dart';
// // // import 'package:go_router/go_router.dart';
// // // import 'package:payme_frontend/pages/loan_dialog.dart';

// // // void showBlurryDialog(BuildContext context, String title, String action) {
// // //   showGeneralDialog(
// // //     context: context,
// // //     barrierDismissible: true,
// // //     barrierColor: Colors.black.withOpacity(0.5), // Dims the background
// // //     pageBuilder: (_, __, ___) => LoanDialog(title: title, action: action),
// // //     transitionBuilder: (context, animation, secondaryAnimation, child) {
// // //       return BackdropFilter(
// // //         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
// // //         child: FadeTransition(
// // //           opacity: animation,
// // //           child: ScaleTransition(
// // //             scale: animation,
// // //             child: child,
// // //           ),
// // //         ),
// // //       );
// // //     },
// // //   );
// // // }

// // // class HomePage extends StatelessWidget {
// // //   const HomePage({Key? key}) : super(key: key);

// // //   String getGreeting() {
// // //     final hour = DateTime.now().hour;
// // //     if (hour < 12) {
// // //       return "Good Morning";
// // //     } else if (hour < 17) {
// // //       return "Good Afternoon";
// // //     } else {
// // //       return "Good Evening";
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     String greeting = getGreeting();
// // //     String username = "Hussain";
// // //     double balance = 1228.0;

// // //     return Scaffold(
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             // Greeting and Notifications
// // //             Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //               children: [
// // //                 Text(
// // //                   "$greeting, $username",
// // //                   style: const TextStyle(
// // //                     fontSize: 20,
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                 ),
// // //                 IconButton(
// // //                   icon: const Icon(Icons.notifications),
// // //                   onPressed: () {
// // //                     print("Notifications clicked!");
// // //                   },
// // //                 ),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 20),

// // //             // Balance
// // //             Container(
// // //               padding: const EdgeInsets.all(16.0),
// // //               decoration: BoxDecoration(
// // //                 color: Colors.blueAccent.withOpacity(0.2),
// // //                 borderRadius: BorderRadius.circular(12),
// // //               ),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   const Text("Balance", style: TextStyle(fontSize: 16)),
// // //                   const SizedBox(height: 8),
// // //                   Row(
// // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                     children: [
// // //                       Text(
// // //                         "$balance KWD",
// // //                         style: const TextStyle(
// // //                           fontSize: 28,
// // //                           fontWeight: FontWeight.bold,
// // //                         ),
// // //                       ),
// // //                      Row(
// // //                       children: [
// // //                         ElevatedButton(
// // //                           onPressed: () {
// // //                             // Call the blurry dialog for Borrow
// // //                             showBlurryDialog(context, "Borrow Money", "Borrow");
// // //                           },
// // //                           child: const Text("Borrow"),
// // //                         ),
// // //                         const SizedBox(width: 10),
// // //                         ElevatedButton(
// // //                           onPressed: () {
// // //                             // Call the blurry dialog for Lend
// // //                             showBlurryDialog(context, "Lend Money", "Lend");
// // //                           },
// // //                           child: const Text("Lend"),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'dart:ui';
// // import 'package:flutter/material.dart';
// // import 'package:payme_frontend/pages/loan_dialog.dart';

// // void showBlurryDialog(BuildContext context, String title, String action) {
// //   showGeneralDialog(
// //     context: context,
// //     barrierDismissible: true,
// //     barrierColor: Colors.black.withOpacity(0.5), 
// //     transitionDuration: const Duration(milliseconds: 300),
// //     pageBuilder: (_, __, ___) => LoanDialog(title: title, action: action),
// //     transitionBuilder: (context, animation, secondaryAnimation, child) {
// //       const double blurSigma = 5.0; 
// //       return BackdropFilter(
// //         filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
// //         child: FadeTransition(
// //           opacity: animation,
// //           child: child,
// //         ),
// //       );
// //     },
// //   );
// // }

// // class HomePage extends StatelessWidget {
// //   const HomePage({Key? key}) : super(key: key);

// //   String getGreeting() {
// //     final hour = DateTime.now().hour;
// //     if (hour < 12) {
// //       return "Good Morning";
// //     } else if (hour < 17) {
// //       return "Good Afternoon";
// //     } else {
// //       return "Good Evening";
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     String greeting = getGreeting();
// //     String username = "Hussain";
// //     double balance = 1228.0;

// //     return Scaffold(
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Text(
// //                   "$greeting, $username",
// //                   style: const TextStyle(
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: const Icon(Icons.notifications),
// //                   onPressed: () {
// //                     print("Notifications clicked!");
// //                   },
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 20),

// //             Container(
// //               padding: const EdgeInsets.all(16.0),
// //               decoration: BoxDecoration(
// //                 color: Colors.blueAccent.withOpacity(0.2),
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text(
// //                     "$balance KWD",
// //                     style: const TextStyle(
// //                       fontSize: 28,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   Row(
// //                     children: [
// //                       ElevatedButton(
// //                         onPressed: () {
// //                           showBlurryDialog(context, "Borrow Money", "Borrow");
// //                         },
// //                         child: const Text("Borrow"),
// //                       ),
// //                       const SizedBox(width: 10),
// //                       ElevatedButton(
// //                         onPressed: () {
// //                           showBlurryDialog(context, "Lend Money", "Lend");
// //                         },
// //                         child: const Text("Lend"),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:ui';
// import 'package:flutter/material.dart';

// class LoanDialog extends StatefulWidget {
//   final String title;
//   final String action;
//   final String? defaultContact;
//   final String? defaultImage;
//   final void Function({
//     required double amount,
//     required String contact,
//     required String profileImage,
//     String? installments,
//     String? duration,
//     String? password,
//   }) onSubmit;

//   const LoanDialog({
//     Key? key,
//     required this.title,
//     required this.action,
//     this.defaultContact,
//     this.defaultImage,
//     required this.onSubmit,
//   }) : super(key: key);

//   @override
//   State<LoanDialog> createState() => _LoanDialogState();
// }

// class _LoanDialogState extends State<LoanDialog> {
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController installmentsController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   String? selectedContactName;
//   String duration = "Monthly";

//   final List<Map<String, dynamic>> contacts = [
//     {"name": "Hamad", "image": "assets/images/1.png"},
//     {"name": "Ghanim", "image": "assets/images/1.png"},
//     {"name": "Abdulwahab", "image": "assets/images/1.png"},
//     {"name": "Meshari", "image": "assets/images/1.png"},
//     {"name": "Yousef", "image": "assets/images/1.png"},
//     {"name": "Reem", "image": "assets/images/1.png"},
//   ];

//   final List<Map<String, dynamic>> installmentDetails = [];

//   @override
//   void initState() {
//     super.initState();
//     passwordController.text = "khadeejah";
//     if (widget.defaultContact != null) {
//       selectedContactName = widget.defaultContact;
//     }
//   }

//   void _calculateInstallments() {
//     double amount = double.tryParse(amountController.text) ?? 0.0;
//     int? installments = int.tryParse(installmentsController.text);
//     installmentDetails.clear();

//     if (installments != null && installments > 0) {
//       double installmentAmount = amount / installments;

//       for (int i = 0; i < installments; i++) {
//         DateTime dueDate = _calculateDueDate(i + 1);
//         installmentDetails.add({
//           "amount": installmentAmount,
//           "dueDate": dueDate.toString().split(" ")[0],
//         });
//       }
//     } else if (amount > 0) {
//       int durationCount = _getDurationCount();
//       if (durationCount > 0) {
//         double installmentAmount = amount / durationCount;

//         for (int i = 0; i < durationCount; i++) {
//           DateTime dueDate = _calculateDueDate(i + 1);
//           installmentDetails.add({
//             "amount": installmentAmount,
//             "dueDate": dueDate.toString().split(" ")[0],
//           });
//         }
//       }
//     }

//     setState(() {});
//   }

//   DateTime _calculateDueDate(int increment) {
//     DateTime now = DateTime.now();
//     switch (duration) {
//       case "Daily":
//         return now.add(Duration(days: increment));
//       case "Weekly":
//         return now.add(Duration(days: increment * 7));
//       case "Monthly":
//         return DateTime(now.year, now.month + increment, now.day);
//       default:
//         return now;
//     }
//   }

//   int _getDurationCount() {
//     switch (duration) {
//       case "Daily":
//         return 30;
//       case "Weekly":
//         return 4;
//       case "Monthly":
//         return 1;
//       default:
//         return 1;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 widget.title,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               DropdownButtonFormField<String>(
//   decoration: const InputDecoration(labelText: "Contact"),
//   value: selectedContactName,
//   items: contacts.map<DropdownMenuItem<String>>((contact) {
//     return DropdownMenuItem<String>(
//       value: contact["name"], // Explicitly set the value as a String
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 12,
//             backgroundImage: AssetImage(contact["image"]),
//           ),
//           const SizedBox(width: 8),
//           Text(contact["name"]),
//         ],
//       ),
//     );
//   }).toList(), // Convert the mapped list to a List<DropdownMenuItem<String>>
//   onChanged: (value) {
//     setState(() {
//       selectedContactName = value;
//     });
//   },
// ),
//               // DropdownButtonFormField<String>(
//               //   decoration: const InputDecoration(labelText: "Contact"),
//               //   value: selectedContactName,
//               //   items: contacts.map((contact) {
//               //     return DropdownMenuItem(
//               //       value: contact["name"],
//               //       child: Row(
//               //         children: [
//               //           CircleAvatar(
//               //             radius: 12,
//               //             backgroundImage: AssetImage(contact["image"]),
//               //           ),
//               //           const SizedBox(width: 8),
//               //           Text(contact["name"]),
//               //         ],
//               //       ),
//               //     );
//               //   }).toList(),
//               //   onChanged: (value) {
//               //     setState(() {
//               //       selectedContactName = value;
//               //     });
//               //   },
//               // ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: amountController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: "Amount (KWD)",
//                   hintText: "Maximum 2000 KWD",
//                 ),
//                 onChanged: (_) => _calculateInstallments(),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: installmentsController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: "Installments (Optional)",
//                   hintText: "Number of installments",
//                 ),
//                 onChanged: (_) => _calculateInstallments(),
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(labelText: "Duration"),
//                 value: duration,
//                 items: ["Daily", "Weekly", "Monthly"].map((value) {
//                   return DropdownMenuItem(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     duration = value!;
//                     _calculateInstallments();
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),
//               if (installmentDetails.isNotEmpty)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Installment Breakdown:",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     SizedBox(
//                       height: 100,
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: installmentDetails.map((detail) {
//                             return Text(
//                               "${detail['dueDate']}: ${detail['amount'].toStringAsFixed(2)} KWD",
//                               style: const TextStyle(
//                                   fontSize: 14, color: Colors.grey),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text("Cancel"),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (selectedContactName != null) {
//                         final selectedContact = contacts.firstWhere(
//                           (contact) => contact["name"] == selectedContactName,
//                         );
//                         widget.onSubmit(
//                           amount: double.tryParse(amountController.text) ?? 0.0,
//                           contact: selectedContact["name"],
//                           profileImage: selectedContact["image"],
//                           installments: installmentsController.text,
//                           duration: duration,
//                           password: passwordController.text,
//                         );
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: Text(widget.action),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// // import 'dart:ui';
// // import 'package:flutter/material.dart';

// // class LoanDialog extends StatefulWidget {
// //   final String title;
// //   final String action;
// //   final String? defaultContact;
// //   final String? defaultImage;
// //   final void Function({
// //     required double amount,
// //     required String contact,
// //     required String profileImage,
// //     String? installments,
// //     String? duration,
// //     String? password,
// //   }) onSubmit;

// //   const LoanDialog({
// //     Key? key,
// //     required this.title,
// //     required this.action,
// //     this.defaultContact,
// //     this.defaultImage,
// //     required this.onSubmit,
// //   }) : super(key: key);

// //   @override
// //   State<LoanDialog> createState() => _LoanDialogState();
// // }

// // class _LoanDialogState extends State<LoanDialog> {
// //   final TextEditingController amountController = TextEditingController();
// //   final TextEditingController installmentsController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();

// //   Map<String, dynamic>? selectedContact;
// //   String duration = "Monthly";

// //   List<Map<String, dynamic>> contacts = [
// //     {"name": "Hamad", "image": "assets/images/1.png"},
// //     {"name": "Ghanim", "image": "assets/images/1.png"},
// //     {"name": "Yousef", "image": "assets/images/1.png"},
// //     {"name": "Reem", "image": "assets/images/1.png"},
// //   ];
// //   List<Map<String, dynamic>> installmentDetails = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     passwordController.text = "khadeejah";
// //     if (widget.defaultContact != null && widget.defaultImage != null) {
// //       selectedContact = {
// //         "name": widget.defaultContact,
// //         "image": widget.defaultImage,
// //       };
// //     }
// //   }

// //   void _calculateInstallments() {
// //     double amount = double.tryParse(amountController.text) ?? 0.0;
// //     int? installments = int.tryParse(installmentsController.text);
// //     installmentDetails.clear();

// //     if (installments != null && installments > 0) {
// //       double installmentAmount = amount / installments;

// //       for (int i = 0; i < installments; i++) {
// //         DateTime dueDate = _calculateDueDate(i + 1);
// //         installmentDetails.add({
// //           "amount": installmentAmount,
// //           "dueDate": dueDate.toString().split(" ")[0],
// //         });
// //       }
// //     } else if (amount > 0) {
// //       int durationCount = _getDurationCount();
// //       if (durationCount > 0) {
// //         double installmentAmount = amount / durationCount;

// //         for (int i = 0; i < durationCount; i++) {
// //           DateTime dueDate = _calculateDueDate(i + 1);
// //           installmentDetails.add({
// //             "amount": installmentAmount,
// //             "dueDate": dueDate.toString().split(" ")[0],
// //           });
// //         }
// //       }
// //     }

// //     setState(() {});
// //   }

// //   DateTime _calculateDueDate(int increment) {
// //     DateTime now = DateTime.now();
// //     switch (duration) {
// //       case "Daily":
// //         return now.add(Duration(days: increment));
// //       case "Weekly":
// //         return now.add(Duration(days: increment * 7));
// //       case "Monthly":
// //         return DateTime(now.year, now.month + increment, now.day);
// //       default:
// //         return now;
// //     }
// //   }

// //   int _getDurationCount() {
// //     switch (duration) {
// //       case "Daily":
// //         return 30;
// //       case "Weekly":
// //         return 4;
// //       case "Monthly":
// //         return 1;
// //       default:
// //         return 1;
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Dialog(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text(
// //                 widget.title,
// //                 style: const TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //               DropdownButtonFormField<Map<String, dynamic>>(
// //                 decoration: const InputDecoration(labelText: "Contact"),
// //                 value: selectedContact,
// //                 items: contacts.map((contact) {
// //                   return DropdownMenuItem(
// //                     value: contact,
// //                     child: Row(
// //                       children: [
// //                         CircleAvatar(
// //                           radius: 12,
// //                           backgroundImage: AssetImage(contact["image"]),
// //                         ),
// //                         const SizedBox(width: 8),
// //                         Text(contact["name"]),
// //                       ],
// //                     ),
// //                   );
// //                 }).toList(),
// //                 onChanged: (value) {
// //                   setState(() {
// //                     selectedContact = value;
// //                   });
// //                 },
// //               ),
// //               const SizedBox(height: 16),
// //               TextFormField(
// //                 controller: amountController,
// //                 keyboardType: TextInputType.number,
// //                 decoration: const InputDecoration(
// //                   labelText: "Amount (KWD)",
// //                   hintText: "Maximum 2000 KWD",
// //                 ),
// //                 onChanged: (_) => _calculateInstallments(),
// //               ),
// //               const SizedBox(height: 16),
// //               TextFormField(
// //                 controller: installmentsController,
// //                 keyboardType: TextInputType.number,
// //                 decoration: const InputDecoration(
// //                   labelText: "Installments (Optional)",
// //                   hintText: "Number of installments",
// //                 ),
// //                 onChanged: (_) => _calculateInstallments(),
// //               ),
// //               const SizedBox(height: 16),
// //               DropdownButtonFormField<String>(
// //                 decoration: const InputDecoration(labelText: "Duration"),
// //                 value: duration,
// //                 items: ["Daily", "Weekly", "Monthly"].map((value) {
// //                   return DropdownMenuItem(
// //                     value: value,
// //                     child: Text(value),
// //                   );
// //                 }).toList(),
// //                 onChanged: (value) {
// //                   setState(() {
// //                     duration = value!;
// //                     _calculateInstallments();
// //                   });
// //                 },
// //               ),
// //               const SizedBox(height: 16),
// //               if (installmentDetails.isNotEmpty)
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text(
// //                       "Installment Breakdown:",
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     SizedBox(
// //                       height: 100,
// //                       child: SingleChildScrollView(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: installmentDetails.map((detail) {
// //                             return Text(
// //                               "${detail['dueDate']}: ${detail['amount'].toStringAsFixed(2)} KWD",
// //                               style: const TextStyle(
// //                                   fontSize: 14, color: Colors.grey),
// //                             );
// //                           }).toList(),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               const SizedBox(height: 16),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   TextButton(
// //                     onPressed: () {
// //                       Navigator.pop(context);
// //                     },
// //                     child: const Text("Cancel"),
// //                   ),
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       if (selectedContact != null) {
// //                         widget.onSubmit(
// //                           amount: double.tryParse(amountController.text) ?? 0.0,
// //                           contact: selectedContact!["name"],
// //                           profileImage: selectedContact!["image"],
// //                           installments: installmentsController.text,
// //                           duration: duration,
// //                           password: passwordController.text,
// //                         );
// //                         Navigator.pop(context);
// //                       }
// //                     },
// //                     child: Text(widget.action),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// // // // import 'dart:ui';
// // // // import 'package:flutter/material.dart';

// // // // class LoanDialog extends StatefulWidget {
// // // //   final String title;
// // // //   final String action;
// // // //   final void Function({
// // // //     required double amount,
// // // //     required String contact,
// // // //     String? installments,
// // // //     String? duration,
// // // //     String? password,
// // // //   }) onSubmit;

// // // //   const LoanDialog({
// // // //     Key? key,
// // // //     required this.title,
// // // //     required this.action,
// // // //     required this.onSubmit,
// // // //   }) : super(key: key);

// // // //   @override
// // // //   State<LoanDialog> createState() => _LoanDialogState();
// // // // }

// // // // class _LoanDialogState extends State<LoanDialog> {
// // // //   final TextEditingController amountController = TextEditingController();
// // // //   final TextEditingController installmentsController = TextEditingController();
// // // //   final TextEditingController passwordController = TextEditingController();
// // // //   String? selectedContact;
// // // //   String duration = "Monthly";

// // // //   final int maxInstallments = 12; // Maximum allowed installments

// // // //   List<String> contacts = ["Hamad", "Ghanim", "Yousef", "Reem"];
// // // //   List<Map<String, dynamic>> installmentDetails = [];

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     passwordController.text = "khadeejah";
// // // //   }

// // // //   void _calculateInstallments() {
// // // //     double amount = double.tryParse(amountController.text) ?? 0.0;
// // // //     int? installments = int.tryParse(installmentsController.text);

// // // //     // Limit installments
// // // //     if (installments != null && installments > maxInstallments) {
// // // //       installments = maxInstallments;
// // // //       installmentsController.text = installments.toString();
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(
// // // //           content: Text("Maximum $maxInstallments installments allowed."),
// // // //         ),
// // // //       );
// // // //     }

// // // //     installmentDetails.clear();

// // // //     // If installments are provided
// // // //     if (installments != null && installments > 0) {
// // // //       double installmentAmount = amount / installments;

// // // //       for (int i = 0; i < installments; i++) {
// // // //         DateTime dueDate = _calculateDueDate(i + 1);
// // // //         installmentDetails.add({
// // // //           "amount": installmentAmount,
// // // //           "dueDate": dueDate.toString().split(" ")[0],
// // // //         });
// // // //       }
// // // //     }
// // // //     // If installments are not provided but duration is selected
// // // //     else if (amount > 0) {
// // // //       int durationCount = _getDurationCount();
// // // //       if (durationCount > 0) {
// // // //         double installmentAmount = amount / durationCount;

// // // //         for (int i = 0; i < durationCount; i++) {
// // // //           DateTime dueDate = _calculateDueDate(i + 1);
// // // //           installmentDetails.add({
// // // //             "amount": installmentAmount,
// // // //             "dueDate": dueDate.toString().split(" ")[0],
// // // //           });
// // // //         }
// // // //       }
// // // //     }

// // // //     setState(() {});
// // // //   }

// // // //   DateTime _calculateDueDate(int increment) {
// // // //     DateTime now = DateTime.now();
// // // //     switch (duration) {
// // // //       case "Daily":
// // // //         return now.add(Duration(days: increment));
// // // //       case "Weekly":
// // // //         return now.add(Duration(days: increment * 7));
// // // //       case "Monthly":
// // // //         return DateTime(now.year, now.month + increment, now.day);
// // // //       default:
// // // //         return now;
// // // //     }
// // // //   }

// // // //   int _getDurationCount() {
// // // //     switch (duration) {
// // // //       case "Daily":
// // // //         return 30;
// // // //       case "Weekly":
// // // //         return 4;
// // // //       case "Monthly":
// // // //         return 1;
// // // //       default:
// // // //         return 1;
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Dialog(
// // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // // //       child: Padding(
// // // //         padding: const EdgeInsets.all(16.0),
// // // //         child: SingleChildScrollView(
// // // //           child: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             mainAxisSize: MainAxisSize.min,
// // // //             children: [
// // // //               Text(
// // // //                 widget.title,
// // // //                 style: const TextStyle(
// // // //                   fontSize: 20,
// // // //                   fontWeight: FontWeight.bold,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(height: 16),
// // // //               DropdownButtonFormField<String>(
// // // //                 decoration: const InputDecoration(labelText: "Contact"),
// // // //                 value: selectedContact,
// // // //                 items: contacts.map((contact) {
// // // //                   return DropdownMenuItem(
// // // //                     value: contact,
// // // //                     child: Text(contact),
// // // //                   );
// // // //                 }).toList(),
// // // //                 onChanged: (value) {
// // // //                   setState(() {
// // // //                     selectedContact = value;
// // // //                   });
// // // //                 },
// // // //               ),
// // // //               const SizedBox(height: 16),
// // // //               TextFormField(
// // // //                 controller: amountController,
// // // //                 keyboardType: TextInputType.number,
// // // //                 decoration: const InputDecoration(
// // // //                   labelText: "Amount (KWD)",
// // // //                   hintText: "Maximum 2000 KWD",
// // // //                 ),
// // // //                 onChanged: (_) => _calculateInstallments(),
// // // //               ),
// // // //               const SizedBox(height: 16),
// // // //               TextFormField(
// // // //                 controller: installmentsController,
// // // //                 keyboardType: TextInputType.number,
// // // //                 decoration: const InputDecoration(
// // // //                   labelText: "Installments (Optional)",
// // // //                   hintText: "Number of installments",
// // // //                 ),
// // // //                 onChanged: (_) => _calculateInstallments(),
// // // //               ),
// // // //               const SizedBox(height: 16),
// // // //               DropdownButtonFormField<String>(
// // // //                 decoration: const InputDecoration(labelText: "Duration"),
// // // //                 value: duration,
// // // //                 items: ["Daily", "Weekly", "Monthly"].map((value) {
// // // //                   return DropdownMenuItem(
// // // //                     value: value,
// // // //                     child: Text(value),
// // // //                   );
// // // //                 }).toList(),
// // // //                 onChanged: (value) {
// // // //                   setState(() {
// // // //                     duration = value!;
// // // //                     _calculateInstallments();
// // // //                   });
// // // //                 },
// // // //               ),
// // // //               const SizedBox(height: 16),
// // // //               if (installmentDetails.isNotEmpty)
// // // //                 Column(
// // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     const Text(
// // // //                       "Installment Breakdown:",
// // // //                       style: TextStyle(
// // // //                         fontSize: 16,
// // // //                         fontWeight: FontWeight.bold,
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(height: 8),
// // // //                     ...installmentDetails.map((detail) {
// // // //                       return Text(
// // // //                         "${detail['dueDate']}: ${detail['amount'].toStringAsFixed(2)} KWD",
// // // //                         style: const TextStyle(fontSize: 14, color: Colors.grey),
// // // //                       );
// // // //                     }).toList(),
// // // //                   ],
// // // //                 ),
// // // //               const SizedBox(height: 16),
// // // //               Row(
// // // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                 children: [
// // // //                   TextButton(
// // // //                     onPressed: () {
// // // //                       Navigator.pop(context);
// // // //                     },
// // // //                     child: const Text("Cancel"),
// // // //                   ),
// // // //                   ElevatedButton(
// // // //                     onPressed: () {
// // // //                       widget.onSubmit(
// // // //                         amount: double.tryParse(amountController.text) ?? 0.0,
// // // //                         contact: selectedContact ?? "",
// // // //                         installments: installmentsController.text,
// // // //                         duration: duration,
// // // //                         password: passwordController.text,
// // // //                       );
// // // //                       Navigator.pop(context);
// // // //                     },
// // // //                     child: Text(widget.action),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'dart:ui';
// // // import 'package:flutter/material.dart';

// // // class LoanDialog extends StatefulWidget {
// // //   final String title;
// // //   final String action;
// // //   final void Function({
// // //     required double amount,
// // //     required String contact,
// // //     String? installments,
// // //     String? duration,
// // //     String? password,
// // //   }) onSubmit;

// // //   const LoanDialog({
// // //     Key? key,
// // //     required this.title,
// // //     required this.action,
// // //     required this.onSubmit,
// // //   }) : super(key: key);

// // //   @override
// // //   State<LoanDialog> createState() => _LoanDialogState();
// // // }

// // // class _LoanDialogState extends State<LoanDialog> {
// // //   final TextEditingController amountController = TextEditingController();
// // //   final TextEditingController installmentsController = TextEditingController();
// // //   final TextEditingController passwordController = TextEditingController();
// // //   String? selectedContact;
// // //   String duration = "Monthly";

// // //   List<String> contacts = ["Hamad", "Ghanim", "Yousef", "Reem"];
// // //   List<Map<String, dynamic>> installmentDetails = [];

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     passwordController.text = "khadeejah";
// // //   }

// // //   void _calculateInstallments() {
// // //     double amount = double.tryParse(amountController.text) ?? 0.0;
// // //     int? installments = int.tryParse(installmentsController.text);
// // //     installmentDetails.clear();

// // //     // If installments are provided
// // //     if (installments != null && installments > 0) {
// // //       double installmentAmount = amount / installments;

// // //       for (int i = 0; i < installments; i++) {
// // //         DateTime dueDate = _calculateDueDate(i + 1);
// // //         installmentDetails.add({
// // //           "amount": installmentAmount,
// // //           "dueDate": dueDate.toString().split(" ")[0],
// // //         });
// // //       }
// // //     }
// // //     // If installments are not provided but duration is selected
// // //     else if (amount > 0) {
// // //       int durationCount = _getDurationCount();
// // //       if (durationCount > 0) {
// // //         double installmentAmount = amount / durationCount;

// // //         for (int i = 0; i < durationCount; i++) {
// // //           DateTime dueDate = _calculateDueDate(i + 1);
// // //           installmentDetails.add({
// // //             "amount": installmentAmount,
// // //             "dueDate": dueDate.toString().split(" ")[0],
// // //           });
// // //         }
// // //       }
// // //     }

// // //     setState(() {});
// // //   }

// // //   DateTime _calculateDueDate(int increment) {
// // //     DateTime now = DateTime.now();
// // //     switch (duration) {
// // //       case "Daily":
// // //         return now.add(Duration(days: increment));
// // //       case "Weekly":
// // //         return now.add(Duration(days: increment * 7));
// // //       case "Monthly":
// // //         return DateTime(now.year, now.month + increment, now.day);
// // //       default:
// // //         return now;
// // //     }
// // //   }

// // //   int _getDurationCount() {
// // //     switch (duration) {
// // //       case "Daily":
// // //         return 30;
// // //       case "Weekly":
// // //         return 4;
// // //       case "Monthly":
// // //         return 1;
// // //       default:
// // //         return 1;
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Dialog(
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: SingleChildScrollView(
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             mainAxisSize: MainAxisSize.min,
// // //             children: [
// // //               Text(
// // //                 widget.title,
// // //                 style: const TextStyle(
// // //                   fontSize: 20,
// // //                   fontWeight: FontWeight.bold,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 16),
// // //               DropdownButtonFormField<String>(
// // //                 decoration: const InputDecoration(labelText: "Contact"),
// // //                 value: selectedContact,
// // //                 items: contacts.map((contact) {
// // //                   return DropdownMenuItem(
// // //                     value: contact,
// // //                     child: Text(contact),
// // //                   );
// // //                 }).toList(),
// // //                 onChanged: (value) {
// // //                   setState(() {
// // //                     selectedContact = value;
// // //                   });
// // //                 },
// // //               ),
// // //               const SizedBox(height: 16),
// // //               TextFormField(
// // //                 controller: amountController,
// // //                 keyboardType: TextInputType.number,
// // //                 decoration: const InputDecoration(
// // //                   labelText: "Amount (KWD)",
// // //                   hintText: "Maximum 2000 KWD",
// // //                 ),
// // //                 onChanged: (_) => _calculateInstallments(),
// // //               ),
// // //               const SizedBox(height: 16),
// // //               TextFormField(
// // //                 controller: installmentsController,
// // //                 keyboardType: TextInputType.number,
// // //                 decoration: const InputDecoration(
// // //                   labelText: "Installments (Optional)",
// // //                   hintText: "Number of installments",
// // //                 ),
// // //                 onChanged: (_) => _calculateInstallments(),
// // //               ),
// // //               const SizedBox(height: 16),
// // //               DropdownButtonFormField<String>(
// // //                 decoration: const InputDecoration(labelText: "Duration"),
// // //                 value: duration,
// // //                 items: ["Daily", "Weekly", "Monthly"].map((value) {
// // //                   return DropdownMenuItem(
// // //                     value: value,
// // //                     child: Text(value),
// // //                   );
// // //                 }).toList(),
// // //                 onChanged: (value) {
// // //                   setState(() {
// // //                     duration = value!;
// // //                     _calculateInstallments();
// // //                   });
// // //                 },
// // //               ),
// // //               const SizedBox(height: 16),
// // //               if (installmentDetails.isNotEmpty)
// // //                 Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     const Text(
// // //                       "Installment Breakdown:",
// // //                       style: TextStyle(
// // //                         fontSize: 16,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     SizedBox(
// // //                       height: 100, // Limit height for scrolling
// // //                       child: SingleChildScrollView(
// // //                         child: Column(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                           children: installmentDetails.map((detail) {
// // //                             return Text(
// // //                               "${detail['dueDate']}: ${detail['amount'].toStringAsFixed(2)} KWD",
// // //                               style: const TextStyle(
// // //                                   fontSize: 14, color: Colors.grey),
// // //                             );
// // //                           }).toList(),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               const SizedBox(height: 16),
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   TextButton(
// // //                     onPressed: () {
// // //                       Navigator.pop(context);
// // //                     },
// // //                     child: const Text("Cancel"),
// // //                   ),
// // //                   ElevatedButton(
// // //                     onPressed: () {
// // //                       widget.onSubmit(
// // //                         amount: double.tryParse(amountController.text) ?? 0.0,
// // //                         contact: selectedContact ?? "",
// // //                         installments: installmentsController.text,
// // //                         duration: duration,
// // //                         password: passwordController.text,
// // //                       );
// // //                       Navigator.pop(context);
// // //                     },
// // //                     child: Text(widget.action),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
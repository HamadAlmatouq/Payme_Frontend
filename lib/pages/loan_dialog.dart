import 'package:flutter/material.dart';

class LoanDialog extends StatelessWidget {
  final String title;
  final String action;
  final void Function({
    required double amount,
    required String contact,
    String? installments,
    String? duration,
    String? password,
  }) onSubmit;

  LoanDialog({
    Key? key,
    required this.title,
    required this.action,
    required this.onSubmit,
  }) : super(key: key);

  final TextEditingController amountController = TextEditingController();
  final TextEditingController installmentsController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final TextEditingController contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final List<String> contacts = ["Hamad", "Ghanim", "Yousef", "Reem"];
    String? selectedContact;
    String selectedDuration = "Monthly";

    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 68, 138, 255),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Contact Dropdown
            DropdownButtonFormField<String>(
              value: selectedContact,
              decoration: const InputDecoration(
                labelText: "Select Contact",
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 68, 138, 255),
                ),
              ),
              items: contacts.map((contact) {
                return DropdownMenuItem(
                  value: contact,
                  child: Text(contact),
                );
              }).toList(),
              onChanged: (String? newValue) {
                selectedContact = newValue;
              },
            ),
            const SizedBox(height: 10),


            // Amount Input
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter amount (KWD)",
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 68, 138, 255),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Installments Input
            TextField(
              controller: installmentsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter installments (Optional)",
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 68, 138, 255),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Duration Dropdown
            DropdownButtonFormField<String>(
              value: selectedDuration,
              decoration: const InputDecoration(
                hintText: "Select duration",
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 68, 138, 255),
                ),
              ),
              items: ["Daily", "Weekly", "Monthly"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                selectedDuration = newValue ?? "Monthly";
              },
            ),
            const SizedBox(height: 10),

            // Password Input
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter password",
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 68, 138, 255),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.face),
                  onPressed: () {
                    passwordController.text = "khadeejah"; // Default
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Color.fromARGB(255, 68, 138, 255),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            double amount = double.tryParse(amountController.text) ?? 0.0;
            String installments = installmentsController.text;
            String password = passwordController.text;

            if (selectedContact == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select a contact."),
                ),
              );
              return;
            }

            if (amount > 0) {
              onSubmit(
                amount: amount,
                contact: selectedContact!,
                installments: installments.isNotEmpty ? installments : null,
                duration: selectedDuration,
                password: password.isNotEmpty ? password : "khadeejah",
              );
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please enter a valid amount."),
                ),
              );
            }
          },
          child: Text(
            action,
            style: const TextStyle(
              color: Color.fromARGB(255, 68, 138, 255),
            ),
          ),
        ),
      ],
    );
  }
}
// // import 'dart:ui';
// // import 'package:flutter/material.dart';
// // import 'package:go_router/go_router.dart';

// // class LoanDialog extends StatefulWidget {
// //   final String title;
// //   final String action; // "Borrow" or "Lend"

// //   const LoanDialog({Key? key, required this.title, required this.action})
// //       : super(key: key);

// //   @override
// //   State<LoanDialog> createState() => _LoanDialogState();
// // }

// // class _LoanDialogState extends State<LoanDialog> {
// //   final List<String> contacts = [];
// //   String? selectedContact;
// //   String duration = "Monthly";
// //   final TextEditingController amountController = TextEditingController();
// //   final TextEditingController installmentsController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     passwordController.text = "khadeejah"; // Default password
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Dialog(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //       backgroundColor: Colors.white.withOpacity(0.85), // Slight transparency
// //       child: Stack(
// //         children: [
// //           // Background blur effect
// //           BackdropFilter(
// //             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
// //             child: Container(),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   // Title
// //                   Text(
// //                     widget.title,
// //                     style: const TextStyle(
// //                       fontSize: 20,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // Contact Dropdown
// //                   DropdownButtonFormField<String>(
// //                     decoration: const InputDecoration(labelText: "Contact"),
// //                     value: selectedContact,
// //                     items: contacts.map((contact) {
// //                       return DropdownMenuItem(
// //                         value: contact,
// //                         child: Text(contact),
// //                       );
// //                     }).toList(),
// //                     onChanged: (value) {
// //                       setState(() {
// //                         selectedContact = value;
// //                       });
// //                     },
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // Amount Field
// //                   TextFormField(
// //                     controller: amountController,
// //                     keyboardType: TextInputType.number,
// //                     decoration: const InputDecoration(
// //                       labelText: "Amount (KWD)",
// //                       hintText: "Maximum 2000 KWD",
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // Installments Field (Optional)
// //                   TextFormField(
// //                     controller: installmentsController,
// //                     keyboardType: TextInputType.number,
// //                     decoration: const InputDecoration(
// //                       labelText: "Installments (Optional)",
// //                       hintText: "Number of installments",
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // Duration Dropdown
// //                   DropdownButtonFormField<String>(
// //                     decoration: const InputDecoration(labelText: "Duration"),
// //                     value: duration,
// //                     items: ["Daily", "Weekly", "Monthly"].map((value) {
// //                       return DropdownMenuItem(
// //                         value: value,
// //                         child: Text(value),
// //                       );
// //                     }).toList(),
// //                     onChanged: (value) {
// //                       setState(() {
// //                         duration = value!;
// //                       });
// //                     },
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // Password Field
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: TextFormField(
// //                           controller: passwordController,
// //                           obscureText: true,
// //                           decoration:
// //                               const InputDecoration(labelText: "Password"),
// //                         ),
// //                       ),
// //                       IconButton(
// //                         icon: const Icon(Icons.face),
// //                         onPressed: () {
// //                           setState(() {
// //                             passwordController.text = "khadeejah";
// //                           });
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // Buttons
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       TextButton(
// //                         onPressed: () {
// //                           context.go('/home'); // Go back to Home Page
// //                         },
// //                         child: const Text("Cancel"),
// //                       ),
// //                       ElevatedButton(
// //                         onPressed: () {
// //                           print("${widget.action} submitted!");
// //                           context.go('/home'); // Go back to Home Page
// //                         },
// //                         child: Text(widget.action),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'dart:ui';
// import 'package:flutter/material.dart';

// class LoanDialog extends StatefulWidget {
//   final String title;
//   final String action; 
//   const LoanDialog({Key? key, required this.title, required this.action})
//       : super(key: key);

//   @override
//   State<LoanDialog> createState() => _LoanDialogState();
// }

// class _LoanDialogState extends State<LoanDialog> {
//   final List<String> contacts = ["Ali", "Sara", "Fahad", "Reem"];
//   String? selectedContact;
//   String duration = "Monthly";
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController installmentsController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     passwordController.text = "khadeejah"; // Default password
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       backgroundColor: Colors.white.withOpacity(0.85), // Slight transparency
//       child: Stack(
//         children: [

//           BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Container(),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     widget.title,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(labelText: "Contact"),
//                     value: selectedContact,
//                     items: contacts.map((contact) {
//                       return DropdownMenuItem(
//                         value: contact,
//                         child: Text(contact),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedContact = value;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   TextFormField(
//                     controller: amountController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: "Amount (KWD)",
//                       hintText: "Maximum 2000 KWD",
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   TextFormField(
//                     controller: installmentsController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: "Installments (Optional)",
//                       hintText: "Number of installments",
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(labelText: "Duration"),
//                     value: duration,
//                     items: ["Daily", "Weekly", "Monthly"].map((value) {
//                       return DropdownMenuItem(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         duration = value!;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller: passwordController,
//                           obscureText: true,
//                           decoration:
//                               const InputDecoration(labelText: "Password"),
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.face),
//                         onPressed: () {
//                           setState(() {
//                             passwordController.text = "khadeejah";
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),

//                   // Buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context); 
//                         },
//                         child: const Text("Cancel"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           print("${widget.action} submitted!");
//                           Navigator.pop(context); 
//                         },
//                         child: Text(widget.action),
//                           ),
//                         ],
//                       ),            
//                     ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
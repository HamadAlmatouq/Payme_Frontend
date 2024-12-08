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
                    passwordController.text = "khadeejah";
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

// lib/screens/signup_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController civilIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value!.isEmpty ? "Enter your username" : null,
              ),
              // TextFormField(
              //   controller: emailController,
              //   decoration: InputDecoration(labelText: 'Email'),
              //   validator: (value) =>
              //       value!.isEmpty ? "Enter your email" : null,
              // ),
              TextFormField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                validator: (value) =>
                    value!.isEmpty ? "Enter your contact" : null,
              ),
              TextFormField(
                controller: civilIdController,
                decoration: InputDecoration(labelText: 'Civil ID'),
                validator: (value) => value!.isEmpty ? "Enter Civil ID" : null,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty) return "Enter password";
                  if (value.length < 4) return "Password too short";
                  return null;
                },
              ),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                validator: (value) {
                  if (value!.isEmpty) return "Confirm your password";
                  if (value != passwordController.text)
                    return "Passwords do not match";
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await context.read<AuthProvider>().signup(
                          username: usernameController.text,
                          password: passwordController.text,
                          email: emailController.text,
                          contact: contactController.text,
                          civilId: civilIdController.text,
                        );
                    context.go("/home");
                  }
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

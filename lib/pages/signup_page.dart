import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController civilIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset('assets/background.mp4')
      ..setLooping(true)
      ..initialize().then((_) => setState(() {}))
      ..play();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video Background
          Positioned.fill(
            child: _videoController.value.isInitialized
                ? VideoPlayer(_videoController)
                : const SizedBox(),
          ),
// Semi-transparent overlay
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
            ),
          ), // Sign Up Form
          Center(
            child: Card(
              color: Colors.white.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '𝐏𝐚𝐲', // 'Pay' in white
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // White color for 'Pay'
                              ),
                            ),
                            TextSpan(
                              text: '𝐌𝐞', // 'Me' in blue
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue, // Blue color for 'Me'
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20), // Add spacing if needed

                      TextFormField(
                        controller: usernameController,
                        style:
                            const TextStyle(color: Colors.blue), // Text color
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: const TextStyle(
                              color: Colors.blue), // Label color
                          filled: true,
                          fillColor: Colors.white
                              .withOpacity(0.8), // Semi-transparent background
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(20.0), // Rounded corners
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue), // Blue focus border
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: const Icon(Icons.person,
                              color: Colors.blue), // Icon
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter your username" : null,
                      ),
                      const SizedBox(height: 20), // Add spacing if needed
                      TextFormField(
                        controller: contactController,
                        style:
                            const TextStyle(color: Colors.blue), // Text color
                        decoration: InputDecoration(
                          labelText: 'Contact',
                          labelStyle: const TextStyle(
                              color: Colors.blue), // Label color
                          filled: true,
                          fillColor: Colors.white
                              .withOpacity(0.8), // Semi-transparent background
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(20.0), // Rounded corners
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue), // Blue focus border
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: const Icon(Icons.phone,
                              color: Colors.blue), // Icon
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter your contact" : null,
                      ),
                      const SizedBox(height: 20), // Add spacing between fields
                      TextFormField(
                        controller: civilIdController,
                        style: const TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                          labelText: 'Civil ID',
                          labelStyle: const TextStyle(color: Colors.blue),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon:
                              const Icon(Icons.badge, color: Colors.blue),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter Civil ID" : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.blue),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.blue),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "Enter password";
                          if (value.length < 4) return "Password too short";
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.blue),
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: const TextStyle(color: Colors.blue),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: Colors.blue),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "Confirm your password";
                          if (value != passwordController.text)
                            return "Passwords do not match";
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // ElevatedButton(
                      //   onPressed: () async {
                      //     if (_formKey.currentState!.validate()) {
                      //       await context.read<AuthProvider>().signup(
                      //             username: usernameController.text,
                      //             password: passwordController.text,
                      //             email: emailController.text,
                      //             contact: contactController.text,
                      //             civilId: civilIdController.text,
                      //           );
                      //       context.go("/home");
                      //     }
                      //   },
                      //   child: const Text(
                      //     'Sign Up',
                      //     style: TextStyle(
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.bold,
                      //       color: Color.fromARGB(255, 36, 145, 254),
                      //     ),
                      //   ),
                      // ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Blue background
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32), // Padding
                          elevation: 5, // Shadow effect
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // White text
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// // lib/screens/signup_page.dart

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';

// class SignUpPage extends StatelessWidget {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController contactController = TextEditingController();
//   final TextEditingController civilIdController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign Up'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: usernameController,
//                 decoration: InputDecoration(labelText: 'Username'),
//                 validator: (value) =>
//                     value!.isEmpty ? "Enter your username" : null,
//               ),
//               // TextFormField(
//               //   controller: emailController,
//               //   decoration: InputDecoration(labelText: 'Email'),
//               //   validator: (value) =>
//               //       value!.isEmpty ? "Enter your email" : null,
//               // ),
//               TextFormField(
//                 controller: contactController,
//                 decoration: InputDecoration(labelText: 'Contact'),
//                 validator: (value) =>
//                     value!.isEmpty ? "Enter your contact" : null,
//               ),
//               TextFormField(
//                 controller: civilIdController,
//                 decoration: InputDecoration(labelText: 'Civil ID'),
//                 validator: (value) => value!.isEmpty ? "Enter Civil ID" : null,
//               ),
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 validator: (value) {
//                   if (value!.isEmpty) return "Enter password";
//                   if (value.length < 4) return "Password too short";
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: confirmPasswordController,
//                 obscureText: true,
//                 decoration: InputDecoration(labelText: 'Confirm Password'),
//                 validator: (value) {
//                   if (value!.isEmpty) return "Confirm your password";
//                   if (value != passwordController.text)
//                     return "Passwords do not match";
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     await context.read<AuthProvider>().signup(
//                           username: usernameController.text,
//                           password: passwordController.text,
//                           email: emailController.text,
//                           contact: contactController.text,
//                           civilId: civilIdController.text,
//                         );
//                     context.go("/home");
//                   }
//                 },
//                 child: Text('Sign Up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

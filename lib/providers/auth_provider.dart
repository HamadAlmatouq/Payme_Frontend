// lib/providers/auth_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:payme_frontend/services/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String token = '';

  // Sign Up
  Future<void> signup({
    required String username,
    required String password,
    required String email,
    required String contact,
    required String civilId,
  }) async {
    try {
      Response response = await Client.dio.post(
        '/auth/signup',
        data: {
          'username': username,
          'password': password,
          'email': email,
          'contact': contact,
          'civilId': civilId,
        },
      );

      print('Signup Response Status: ${response.statusCode}');
      print('Signup Response Data: ${response.data}');

      if (response.statusCode == 201 &&
          response.data != null &&
          response.data['token'] != null) {
        token = response.data['token'] as String;
        print('Token received: $token');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        print('Token saved to SharedPreferences');
      } else {
        print('Signup failed to get token');
      }
    } catch (e) {
      print('Signup request error: $e');
    }
  }

  Future<bool> signin({
    required String username,
    required String password,
  }) async {
    try {
      Response response = await Client.dio.post(
        '/auth/signin',
        data: {
          'username': username,
          'password': password,
        },
      );

      print('Sign-In Response Status: ${response.statusCode}');
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['token'] != null) {
        token = response.data['token'] as String;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        print('Token saved to SharedPreferences');
        return true;
      } else {
        print('Sign-In failed');
        return false;
      }
    } catch (e) {
      print('Sign-In request error: $e');
      return false;
    }
  }
}

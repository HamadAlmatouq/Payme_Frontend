import 'dart:io';
import 'package:flutter/material.dart';
import 'package:payme_frontend/models/user.dart';
import 'package:payme_frontend/services/auth.dart';
import 'package:payme_frontend/services/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? token; //"error", "email", "token"
  User? user;

  Future<Map<String, String>> signup(
      {required String username, required String password}) async {
    var response = await AuthServices()
        .signup(user: User(username: username, password: password));
    if (response['token'] != null) {
      _setToken(username, response['token']!);
    }
    print(response['token'] ?? 'No token');
    notifyListeners();
    return response;
  }

  Future<Map<String, String>> signin(
      {required String username, required String password}) async {
    var response = await AuthServices()
        .signin(user: User(username: username, password: password));
    // this.user = user;
    if (response['token'] != null) {
      _setToken(username, response['token']!);
    }
    // print(token);
    notifyListeners();
    return response;
  }

  bool isAuth() {
    // print(user ?? 'No User');
    // print(token ?? 'No token');
    return (user != null && token != null);
  }

  Future<void> initAuth() async {
    print("initAuth");
    await _getToken();
    if (isAuth()) {
      Client.dio.options.headers = {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };
      user = User(username: user!.username, password: token);
      print('Bearer $token');
      notifyListeners();
    }
  }

  void _setToken(String username, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.token = token;
    user = User(username: username, password: token);
    prefs.setString("username", username);
    // prefs.setString("password", username);
    prefs.setString("token", token);
    notifyListeners();
  }

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString("username");
    var token = prefs.getString("token");

    if (username == null || token == null) return;

    user = User(username: username, password: token);
    this.token = token;
    notifyListeners();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('token');
    user = null;
    token = null;
    notifyListeners();
  }
}

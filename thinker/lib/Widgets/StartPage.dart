import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thinker/HomePage.dart';
import 'package:thinker/Widgets/AuthPage.dart';
import 'package:thinker/login.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String accessToken;

  // Future<void> _refreshToken() async {
  //   try {
  //     final uri = Uri.https('thinkerr.herokuapp.com', '/user/auth/refresh', {
  //       "refresh_token":
  //           "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1dWlkIjoiOGUzZmIzMWEtYzAxMi00YjFlLWJkMjAtZmMyZjM4YTY2NjY4IiwiZXhwIjoxNjYwMjQ0ODI2LCJpYXQiOjE2NjAyMjY4MjZ9.VHG4YZlDznsA_sT6yub9e7ijQ89CR8sEJa9fB-MmDuU"
  //     });
  //     final response = await http.get(uri);
  //     var res_data = jsonDecode(response.body);
  //     // print(res_data["refresh_token"]);
  //     final SharedPreferences prefs = await _prefs;
  //     prefs.setString("access_token", res_data["access_token"]);
  //     prefs.setString("refresh_token", res_data["refresh_token"]);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // _refreshToken();
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return AuthPage();
          } else {
            return LogIn();
          }
        },
      ),
    );
  }
}

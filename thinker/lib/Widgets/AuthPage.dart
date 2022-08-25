import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinker/HomePage.dart';
import 'package:thinker/utils/UserData.dart' as UserDataBase;

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Map userData;
  late String accessToken;
  final user = FirebaseAuth.instance.currentUser!;

  Future _getUserInfo(String access_token) async {
    var client = http.Client();
    var response = await client.get(
        Uri.parse(
            'http://thinkerr.herokuapp.com/user/get_info?uuid=${user.uid}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic ${access_token}',
        });
    UserDataBase.UserData = jsonDecode(response.body)["data"];
    // userData = jsonDecode(response.body)["data"];
    return userData;
  }

  Future<void> _authorisation() async {
    try {
      var client = http.Client();
      try {
        var response = await client
            .post(Uri.https('thinkerr.herokuapp.com', '/user/auth'), body: {
          "uuid": user.uid,
          "name": user.displayName,
          "email": user.email,
          "bio": "",
          "photo_url": user.photoURL
        });
        print(user.uid);
        print(user.displayName);
        print(user.email);
        print(user.photoURL);
        var reqData = jsonDecode(response.body);
        final SharedPreferences prefs = await _prefs;
        prefs.setString("access_token", reqData["data"]["access_token"]);
        prefs.setString("refresh_token", reqData["data"]["refresh_token"]);
        _getUserInfo(reqData["data"]["access_token"]).then((value) {
          // print(value);
          return reqData;
        });
      } finally {
        client.close();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _authorisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _authorisation().then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          (Route<dynamic> route) => false);
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Taking You In!"),
            SizedBox(
              height: 15,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

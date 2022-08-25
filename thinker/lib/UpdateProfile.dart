import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thinker/HomePage.dart';
import 'package:thinker/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

late String accessToken;
final user = FirebaseAuth.instance.currentUser!;

late String _username;
late String _bio;

Future<void> _updateProfile(BuildContext _context) async {
  try {
    final SharedPreferences prefs = await _prefs;
    final access_token = prefs.getString("access_token");
    showDialog(
        barrierDismissible: false,
        context: _context,
        builder: (_) {
          return Dialog(
            child: Container(
              height: 200,
              width: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
    var client = http.Client();
    try {
      var response = await client
          .patch(Uri.https('thinkerr.herokuapp.com', '/user/auth'), body: {
        "name": _username,
        "bio": _bio,
      }, headers: {
        HttpHeaders.authorizationHeader: 'Basic ${access_token}',
      });
      var reqData = jsonDecode(response.body);
      Navigator.of(_context).pop();
      return reqData;
    } finally {
      client.close();
    }
  } catch (e) {
    print(e);
  }
}

class _UpdateProfileState extends State<UpdateProfile> {
  @override
  Widget build(BuildContext contextNew) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Profile Details",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Color(0xff403F3F).withOpacity(0.57),
                    borderRadius: BorderRadius.circular(120),
                  ),
                  child: Center(
                    child: Image.asset("assets/avatar.png"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Username",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Color(0xff100F15).withOpacity(0.68),
                          width: 1.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  onChanged: (text) {
                    _username = text;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Bio",
                    hintText: "Write something cool about yourself!",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Color(0xff100F15).withOpacity(0.68),
                          width: 1.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  maxLines: 6,
                  onChanged: (text) {
                    _bio = text;
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                LogInLogOutBtn(
                  title: "Update",
                  onTap: () {
                    _updateProfile(contextNew).then((value) {
                      Navigator.of(context).pop();
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

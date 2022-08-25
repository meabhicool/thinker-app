import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thinker/HomePage.dart';
import 'package:thinker/Signup.dart';
import 'package:thinker/UpdateProfile.dart';
import 'package:http/http.dart' as http;
//-->
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:thinker/Widgets/AuthPage.dart';
import 'package:thinker/utils/google_sign_in.dart';

class LogIn extends StatelessWidget {
  var data;
  bool _hidePass = true;

  @override
  Widget build(BuildContext context) {
    String _email = "";
    String _password = "";
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 20, left: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Welcome back!",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Username",
                    contentPadding: const EdgeInsets.all(20),
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
                  onChanged: (email) {
                    _email = email;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: _hidePass,
                  decoration: InputDecoration(
                    labelText: "Password",
                    contentPadding: const EdgeInsets.all(20),
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
                  onChanged: (pass) {
                    _password = pass;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                LogInLogOutBtn(
                  title: "Login",
                  onTap: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    showDialog(
                        barrierDismissible: false,
                        context: context,
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
                    provider.EmailLogIn(_email, _password).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.blueAccent,
                          content: Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                      Navigator.of(context).pop();
                    });
                    // var client = http.Client();
                    // var response = await client.post(
                    //     Uri.https('thinkerr.herokuapp.com', '/user/auth'),
                    //     body: {
                    //       "uuid": "8e3fb31a-c012-4b1e-bd20-fc2f38a66668",
                    //       "name": "User",
                    //       "email": "user@gmail.com",
                    //       "photo_url":
                    //           "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
                    //     });
                    // // data = jsonDecode(response.body);
                    // if (jsonDecode(response.body)["code"] == 200) {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (BuildContext context) =>
                    //               UpdateProfile()));
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text('Yay! A SnackBar!'),
                    //     ),
                    //   );
                    // }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 2,
                      width: 80,
                      color: Color(0xff100F15).withOpacity(0.38),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "OR",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 2,
                      width: 80,
                      color: Color(0xff100F15).withOpacity(0.38),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                LogInLogOutBtn(
                  title: "Continue with Google",
                  icon: "assets/google_logo.png",
                  onTap: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.googleLogin().then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => AuthPage(),
                          ),
                        ));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                LogInLogOutBtn(
                  title: "Continue with Apple",
                  icon: "assets/apple_logo.png",
                  onTap: () {},
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Don't have account? Signup",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => SignUp()));
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogInLogOutBtn extends StatelessWidget {
  const LogInLogOutBtn({
    required this.title,
    this.icon,
    required this.onTap,
  });

  final String title;
  final String? icon;
  final VoidCallback onTap;

  getIcon() {
    if (icon != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Container(
          child: Image.asset(
            icon!,
            width: 30,
            height: 30,
          ),
        ),
      );
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff00ADB5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getIcon(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

class LogInTextField extends StatelessWidget {
  const LogInTextField({required this.label});

  // final Function onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.all(20),
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
    );
  }
}

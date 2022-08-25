import 'package:flutter/material.dart';
import 'package:thinker/Signup.dart';
//-->

import 'package:provider/provider.dart';
import 'package:thinker/Widgets/AuthPage.dart';
import 'package:thinker/utils/google_sign_in.dart';

class LogInNew extends StatelessWidget {
  var data;
  bool _hidePass = true;

  @override
  Widget build(BuildContext context) {
    String _email = "";
    String _password = "";
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Welcome back!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    "Create and share awesome cards with peoples around the globe. \n Exchange ideas and knowledge",
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/creative.png",
                  height: 250,
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

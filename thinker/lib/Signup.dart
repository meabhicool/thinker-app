import 'package:flutter/material.dart';

import 'login.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Welcome to \nThinker!",
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
                LogInTextField(label: "Email Address"),
                SizedBox(
                  height: 20,
                ),
                LogInTextField(label: "Username"),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                LogInTextField(label: "Password"),
                SizedBox(
                  height: 20,
                ),
                LogInLogOutBtn(
                  title: "Signup",
                  onTap: () {},
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
                  title: "Signup with Google",
                  icon: "assets/google_logo.png",
                  onTap: () {},
                ),
                SizedBox(
                  height: 20,
                ),
                LogInLogOutBtn(
                  title: "Signup with Apple",
                  icon: "assets/apple_logo.png",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

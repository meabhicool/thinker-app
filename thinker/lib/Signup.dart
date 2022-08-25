import 'package:flutter/material.dart';
import 'package:thinker/utils/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'login.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _hidePass = true;
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
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
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
                  height: 20,
                ),
                LogInLogOutBtn(
                  title: "Signup",
                  onTap: () {
                    // final provider = Provider.of<GoogleSignInProvider>(context,
                    //     listen: false);
                    // showDialog(
                    //     barrierDismissible: false,
                    //     context: context,
                    //     builder: (_) {
                    //       return Dialog(
                    //         child: Container(
                    //           height: 200,
                    //           width: 100,
                    //           child: Center(
                    //             child: CircularProgressIndicator(),
                    //           ),
                    //         ),
                    //       );
                    //     });
                    // provider.emailSignup(_email, _password).then((value) {
                    //   print(_email);
                    //   print(_password);
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       behavior: SnackBarBehavior.floating,
                    //       backgroundColor: Colors.blueAccent,
                    //       content: Text(
                    //         value,
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //     ),
                    //   );
                    //   Navigator.of(context).pop();
                    // });
                  },
                ),
                SizedBox(
                  height: 60,
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
                  height: 60,
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

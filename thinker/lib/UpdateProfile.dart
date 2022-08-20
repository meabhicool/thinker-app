import 'package:flutter/material.dart';
import 'package:thinker/HomePage.dart';
import 'package:thinker/login.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  @override
  Widget build(BuildContext context) {
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
                ),
                SizedBox(
                  height: 50,
                ),
                LogInLogOutBtn(
                  title: "Get Started",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomePage()));
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

import 'package:flutter/material.dart';
import 'package:thinker/Widgets/Onboard_Widget.dart';
import 'package:thinker/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => OnBoardScreenState();
}

class OnBoardScreenState extends State<OnBoardScreen> {
  var ind = 0;
  void next_index() {
    if (ind != 2) {
      ind = ind + 1;
    }
  }

  void prev_index() {
    if (ind != 0) {
      ind = ind - 1;
    }
  }

  bool isNew = false;
  //
  // Future<void> _setIsNewDevice() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isNew', false);
  // }

  @override
  Widget build(BuildContext context) {
    List data = [
      {
        "index": 0,
        "title": "Create Cards, Publish them!",
        "para":
            "Proident Lorem voluptate est exercitation culpa minim est voluptate minim duis labore reprehenderit. Incididunt consequat eu esse qui."
      },
      {
        "index": 1,
        "title": "Login & Signup screens!",
        "para":
            "Proident Lorem voluptate est exercitation culpa minim est voluptate minim duis labore reprehenderit. Incididunt consequat eu esse qui."
      },
      {
        "index": 2,
        "title": "How Flash cards help you learn?",
        "para":
            "Proident Lorem voluptate est exercitation culpa minim est voluptate minim duis labore reprehenderit. Incididunt consequat eu esse qui."
      },
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.80,
              child: OnBoard_Widget(
                  data[ind]["index"], data[ind]["title"], data[ind]["para"]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: (this.ind > 0)
                                ? Color(0xff222831)
                                : Colors.grey,
                          ),
                          Text(
                            "Prev",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: (this.ind > 0)
                                    ? Color(0xff222831)
                                    : Colors.grey),
                          )
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          prev_index();
                        });
                      },
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          Text(
                            ind < 2 ? "Next" : "Finish",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff222831),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xff222831),
                          )
                        ],
                      ),
                      onTap: () {
                        if (ind < 2) {
                          setState(() {
                            next_index();
                          });
                        } else {
                          // _setIsNewDevice();
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) => LogIn()));
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

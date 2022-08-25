import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:thinker/CardView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:thinker/UpdateProfile.dart';
import 'package:thinker/utils/UserData.dart' as UserData;
import 'package:thinker/login.dart';
import 'package:thinker/utils/google_sign_in.dart';

class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({Key? key}) : super(key: key);

  @override
  State<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final user = FirebaseAuth.instance.currentUser!;
  var createdCards = [];
  var bookmarkedCards = [];

  Future _getCreatedCards() async {
    final SharedPreferences prefs = await _prefs;
    final access_token = prefs.getString("access_token");
    var client = http.Client();
    var response = await client.get(
        Uri.parse('http://thinkerr.herokuapp.com/deck/get_created'),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic ${access_token}',
        });
    var data = jsonDecode(response.body);
    createdCards = data["data"];
    // print(createdCards);
    return createdCards;
  }

  Future _getSavedCards() async {
    final SharedPreferences prefs = await _prefs;
    final access_token = prefs.getString("access_token");
    var client = http.Client();
    var response = await client.get(
        Uri.parse('http://thinkerr.herokuapp.com/deck/get_bookmarked_decks/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic ${access_token}',
        });
    var data = jsonDecode(response.body);
    bookmarkedCards = data["data"];
    // print(createdCards);
    return bookmarkedCards;
  }

  Future _remBookmark(int deckId, BuildContext context) async {
    final SharedPreferences prefs = await _prefs;
    final access_token = prefs.getString("access_token");
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
    var client = http.Client();
    var response = await client.patch(
        Uri.parse(
            'https://thinkerr.herokuapp.com/deck/remove_bookmark/?id=${deckId}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic ${access_token}',
        });
    var data = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueAccent,
        content: Text(
          data["message"],
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    Navigator.of(context).pop();
    return data["code"];
  }

  Future _delCardData(int deckId, BuildContext context) async {
    final SharedPreferences prefs = await _prefs;
    final access_token = prefs.getString("access_token");
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
    var client = http.Client();
    var response = await client.delete(
        Uri.parse('https://thinkerr.herokuapp.com/deck/delete/?id=${deckId}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic ${access_token}',
        });
    var data = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueAccent,
        content: Text(
          data["message"],
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    Navigator.of(context).pop();
    return data["code"];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 5,
                      blurRadius: 8,
                      offset: Offset(2, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  UserData.UserData["name"],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Text(
                  UserData.UserData["email"],
                  style: TextStyle(
                    color: Color(0xff222831).withOpacity(.6),
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => UpdateProfile(),
                    ),
                  );
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 100),
                    child: Text(
                      "EDIT PROFILE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1.0, color: Colors.black)),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              // InkWell(
              //   onTap: () {
              //     final provider =
              //         Provider.of<GoogleSignInProvider>(context, listen: false);
              //     provider.logout().then((value) {
              //       Navigator.pushAndRemoveUntil(
              //           context,
              //           MaterialPageRoute(
              //               builder: (BuildContext context) => LogIn()),
              //           (Route<dynamic> route) => false);
              //     });
              //   },
              //   child: Container(
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(
              //           vertical: 8.0, horizontal: 120),
              //       child: Text(
              //         "Log Out",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 12,
              //         ),
              //       ),
              //     ),
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(8),
              //         border: Border.all(width: 1.0, color: Colors.black)),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              // Row(
              //   children: [
              //     InkWell(
              //       child: Container(
              //         width: ((MediaQuery.of(context).size.width - 45) / 3) * 2,
              //         height: ((MediaQuery.of(context).size.width - 40) / 3) * 2,
              //         decoration: BoxDecoration(
              //           color: Colors.redAccent,
              //           borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(15),
              //           ),
              //         ),
              //       ),
              //       onTap: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (BuildContext context) => CardView()));
              //       },
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(left: 15.0),
              //       child: Column(
              //         children: [
              //           Container(
              //             width: (MediaQuery.of(context).size.width - 60) / 3,
              //             height: (MediaQuery.of(context).size.width - 60) / 3,
              //             decoration: BoxDecoration(
              //               color: Colors.redAccent,
              //               borderRadius: BorderRadius.only(
              //                 topRight: Radius.circular(15),
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             height: 15,
              //           ),
              //           Container(
              //             width: (MediaQuery.of(context).size.width - 60) / 3,
              //             height: (MediaQuery.of(context).size.width - 60) / 3,
              //             color: Colors.redAccent,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // SmallCardsRow(),
              // SmallCardsRow(),
              // SmallCardsRow(
              //   isLast: true,
              // ),
              Container(
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        "My Cards",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Tab(
                        child: Text(
                      "Saved Cards",
                      style: TextStyle(color: Colors.black),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height - 250,
                child: TabBarView(
                  // physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      height: 1080,
                      child: FutureBuilder(
                        future: _getCreatedCards(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (createdCards.length != 0) {
                            return Container(
                              height: MediaQuery.of(context).size.height - 450,
                              child: GridView.builder(
                                itemCount: createdCards.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              CardView(
                                                  userName: user.displayName!,
                                                  userImg: user.photoURL,
                                                  backgroundImage:
                                                      createdCards[index]
                                                          ["image"],
                                                  views: createdCards[index]
                                                      ["views"],
                                                  deckId: createdCards[index]
                                                      ["id"],
                                                  topic: createdCards[index]
                                                      ["topic"]),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(.2),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  createdCards[index]["topic"],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            ),
                                          ),
                                          height: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50) /
                                              2,
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50) /
                                              2,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    createdCards[index]
                                                        ["image"],
                                                  ),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 20,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(.7),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Center(
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                  size: 30,
                                                ),
                                                onPressed: () {
                                                  _delCardData(
                                                          createdCards[index]
                                                              ["id"],
                                                          context)
                                                      .then((value) {
                                                    if (value == 200) {
                                                      setState(() {});
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (createdCards.length == 0) {
                            return Center(
                              child: Text("Ooops ! No cards Found"),
                            );
                          } else {
                            return Center(
                              child: Text("Ooops ! Error fetching data."),
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                      child: FutureBuilder(
                        future: _getSavedCards(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (bookmarkedCards.length != 0) {
                            return Container(
                              height: MediaQuery.of(context).size.height - 450,
                              child: GridView.builder(
                                itemCount: bookmarkedCards.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              CardView(
                                                  userName: user.displayName!,
                                                  userImg: user.photoURL,
                                                  backgroundImage:
                                                      bookmarkedCards[index]
                                                          ["image"],
                                                  views: bookmarkedCards[index]
                                                      ["views"],
                                                  deckId: bookmarkedCards[index]
                                                      ["id"],
                                                  topic: bookmarkedCards[index]
                                                      ["topic"]),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(.2),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  bookmarkedCards[index]
                                                      ["topic"],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            ),
                                          ),
                                          height: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50) /
                                              2,
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50) /
                                              2,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    bookmarkedCards[index]
                                                        ["image"],
                                                  ),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 20,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(.7),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Center(
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.bookmark_remove,
                                                  color: Colors.redAccent,
                                                  size: 30,
                                                ),
                                                onPressed: () {
                                                  _remBookmark(
                                                          bookmarkedCards[index]
                                                              ["id"],
                                                          context)
                                                      .then((value) {
                                                    if (value == 200) {
                                                      setState(() {});
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (bookmarkedCards.length == 0) {
                            return Center(
                              child: Text("Ooops ! No cards Found"),
                            );
                          } else {
                            return Center(
                              child: Text("Ooops ! Error fetching data."),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 70,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SmallCardsRow extends StatelessWidget {
  const SmallCardsRow({this.isLast = false});

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Container(
              width: (MediaQuery.of(context).size.width - 67) / 3,
              height: (MediaQuery.of(context).size.width - 60) / 3,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      isLast == true ? Radius.circular(15) : Radius.circular(0),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              width: (MediaQuery.of(context).size.width - 67) / 3,
              height: (MediaQuery.of(context).size.width - 60) / 3,
              color: Colors.redAccent,
            ),
            SizedBox(
              width: 16,
            ),
            Container(
              width: (MediaQuery.of(context).size.width - 67) / 3,
              height: (MediaQuery.of(context).size.width - 60) / 3,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  bottomRight:
                      isLast == true ? Radius.circular(15) : Radius.circular(0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thinker/SearchPage.dart';
import 'package:thinker/Widgets/HomePageWidget.dart';
import 'package:thinker/Widgets/ProfilePageWidget.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:thinker/Widgets/SearchPageCreateCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

int _navigationIndex = 0;
void _setIndex(index) {
  _navigationIndex = index;
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: _navigationIndex == 0
                ? Icon(
                    Icons.notifications_none_outlined,
                    size: 30,
                    color: Color(0xff222831),
                  )
                : Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Color(0xff222831),
                  ),
            onPressed: () {
              setState(() {
                _setIndex(0);
              });
            },
          ),
        ),
        title: _navigationIndex == 0
            ? Image.asset(
                "assets/Thinker.png",
                width: 120,
              )
            : Text(
                "@${(user.displayName!.toLowerCase()).replaceAll(" ", "_")}",
                style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: _navigationIndex == 0
                  ? Icon(
                      Icons.search,
                      size: 30,
                      color: Color(0xff222831),
                    )
                  : Icon(
                      Icons.settings,
                      size: 30,
                      color: Color(0xff222831),
                    ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        _navigationIndex == 0 ? SearchPage() : HomePage(),
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: (_navigationIndex == 0) ? HomePageWidget() : ProfilePageWidget(),
      bottomNavigationBar: BottomAppBar(
        elevation: 20,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _setIndex(0);
                  });
                },
                icon: Icon(
                  Icons.home,
                  color: Color(0xff00ADB5),
                  size: 35,
                ),
              ),
              InkWell(
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
                onTap: () {
                  setState(() {
                    _setIndex(1);
                  });
                },
              ),
            ],
          ),
        ),
        notchMargin: 12,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xff00ADB5),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SearchPageCreate(),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

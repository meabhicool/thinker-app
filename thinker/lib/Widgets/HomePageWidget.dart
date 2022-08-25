import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../CardView.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

List _cardsData = [];

Future _getCards() async {
  final SharedPreferences prefs = await _prefs;
  final access_token = prefs.getString("access_token");
  var client = http.Client();
  var response = await client.get(
      Uri.parse('https://thinkerr.herokuapp.com/deck/home_feed?page=1'),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic ${access_token}',
      });
  var _cardsDataTemp = jsonDecode(response.body);
  _cardsData = _cardsDataTemp["results"];
  // print(_cardsData);
  return _cardsData;
}

class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Flash Cards",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 140,
            child: FutureBuilder(
                future: _getCards(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: HomePageCards(
                            cardTitle: _cardsData[index]["topic"],
                            bgImage: _cardsData[index]["image"],
                            avatarImage: _cardsData[index]["user_photo_url"],
                            userName: _cardsData[index]["user_name"],
                            views: _cardsData[index]["views"],
                            deckId: _cardsData[index]["id"],
                          ),
                        );
                      },
                      itemCount: _cardsData.length,
                    );
                  } else {
                    return Center(
                      child: Text("Something Went Wrong !"),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}

class HomePageCards extends StatelessWidget {
  const HomePageCards({
    required this.cardTitle,
    required this.bgImage,
    this.avatarImage,
    required this.userName,
    this.views,
    this.deckId,
  });

  final String cardTitle;
  final String bgImage;
  final String? avatarImage;
  final String userName;
  final int? views;
  final deckId;

  Future _bookmarkCard(int id, BuildContext context) async {
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
        Uri.parse('http://thinkerr.herokuapp.com/deck/bookmark/?id=${id}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic ${access_token}',
        });
    var data = jsonDecode(response.body);
    print(data);
    Navigator.of(context).pop();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(bgImage), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CardView(
                          views: this.views!,
                          backgroundImage: this.bgImage,
                          deckId: this.deckId,
                          topic: this.cardTitle,
                          userImg: this.avatarImage,
                          userName: this.userName,
                        )));
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              cardTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              "$views Views",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(avatarImage!),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  userName,
                  style: TextStyle(fontSize: 13),
                )
              ],
            ),
            IconButton(
                onPressed: () {
                  _bookmarkCard(deckId, context).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.blueAccent,
                      content: Text(
                        value["message"],
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
                  });
                },
                icon: Icon(Icons.bookmark_outline_outlined))
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

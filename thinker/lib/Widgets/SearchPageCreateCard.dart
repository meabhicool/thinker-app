import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thinker/CreatePage.dart';

class SearchPageCreate extends StatefulWidget {
  const SearchPageCreate({Key? key}) : super(key: key);

  @override
  State<SearchPageCreate> createState() => _SearchPageCreateState();
}

class _SearchPageCreateState extends State<SearchPageCreate> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List _searchRes = [];
  var searchKey = "";
  var _searchDataTemp;

  Future _getResults() async {
    final SharedPreferences prefs = await _prefs;
    final access_token = prefs.getString("access_token");
    var client = http.Client();
    var response = await client.get(
        Uri.parse(
            'http://thinkerr.herokuapp.com/deck/search/?topic=${searchKey}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic ${access_token}',
        });
    _searchDataTemp = jsonDecode(response.body);
    _searchRes = _searchDataTemp["results"];
    return _searchRes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Looking For Something ??",
                    contentPadding: const EdgeInsets.all(20),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
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
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: Icon(Icons.search),
                    ),
                  ),
                  onChanged: (text) {
                    searchKey = text;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: _getResults(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (_searchRes.length != 0) {
                      return Container(
                        height: MediaQuery.of(context).size.height - 155,
                        child: ListView.builder(
                            itemCount: _searchRes.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index < _searchRes.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: SearchResultCards(
                                    cardData: _searchRes[index],
                                  ),
                                );
                              } else {
                                return NotFoundCard();
                              }
                            }),
                      );
                    } else if (_searchDataTemp["count"] == 0) {
                      // print(snapshot);
                      return Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            NotFoundCard(),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                          height: MediaQuery.of(context).size.height - 100,
                          child: SearchNullWidget());
                    }
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

class NotFoundCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: BoxDecoration(
          color: Color(0xff00ADB5), borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "Didn't Find What you was looking for ?",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.amber, borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CreateCardPage(),
                    ),
                  );
                },
                child: Text(
                  "Let's Create",
                  style: TextStyle(color: Color(0xff1C1C1C)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SearchResultCards extends StatelessWidget {
  const SearchResultCards({required this.cardData});

  final Map cardData;

  @override
  Widget build(BuildContext context) {
    // print(cardData);
    return Stack(
      children: [
        Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: NetworkImage(
                  cardData["image"],
                ),
                fit: BoxFit.cover),
          ),
        ),
        Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(.7),
                Colors.black.withOpacity(0.0)
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardData["topic"],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color(0xffFBFDFD)),
                ),
                Text(
                  cardData["user_name"],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xffFBFDFD).withOpacity(.56)),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SearchNullWidget extends StatelessWidget {
  const SearchNullWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/SearchPageCreate.png",
          height: 200,
          width: 200,
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Let's see if someone has already made it for you !",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff222831).withOpacity(.59),
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

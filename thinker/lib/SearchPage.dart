import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List _searchRes = [];
  var searchKey = "";

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
    var _searchDataTemp = jsonDecode(response.body);
    _searchRes = _searchDataTemp["results"];
    print(_searchRes);
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
                        height: MediaQuery.of(context).size.height - 100,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _searchRes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: SearchResultCards(
                                  cardData: _searchRes[index],
                                ),
                              );
                            }),
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

class SearchResultCards extends StatelessWidget {
  const SearchResultCards({required this.cardData});

  final Map cardData;

  @override
  Widget build(BuildContext context) {
    print(cardData);
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
          "assets/SearchPageNull.png",
          height: 200,
          width: 200,
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Search for information, search for knowledge!",
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

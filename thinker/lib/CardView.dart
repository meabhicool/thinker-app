import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardView extends StatefulWidget {
  CardView(
      {required this.backgroundImage,
      required this.views,
      required this.deckId,
      required this.topic});

  final String backgroundImage;
  final int views;
  final int deckId;
  final String topic;

  @override
  State<CardView> createState() => _CardViewState();
}

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
final user = FirebaseAuth.instance.currentUser!;

List _cardData = [];

Future _getCardData(int deckId) async {
  final SharedPreferences prefs = await _prefs;
  final access_token = prefs.getString("access_token");
  var client = http.Client();
  print(deckId);
  var response = await client.get(
      Uri.parse('https://thinkerr.herokuapp.com/deck/cards?deck_id=${deckId}'),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic ${access_token}',
      });
  var data = jsonDecode(response.body);
  _cardData = data["data"];
  print(data["data"]);
  return data["data"];
}

class _CardViewState extends State<CardView> {
  @override
  Widget build(BuildContext context) {
    print(widget.backgroundImage);
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: _getCardData(widget.deckId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    CarouselSlider(
                      items: _cardData.asMap().entries.map((e) {
                        return SavedCardWidget(
                          index: e.key,
                          text: e.value["content"],
                          bgImage: widget.backgroundImage,
                        );
                      }).toList(),
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        height: MediaQuery.of(context).size.height,
                        viewportFraction: 1,
                        enlargeCenterPage: true,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 10,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // Positioned(
                    //   right: 20,
                    //   top: MediaQuery.of(context).size.height / 3,
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(50),
                    //       color: Color(0xffFBFDFD).withOpacity(.6),
                    //     ),
                    //     child: IconButton(
                    //       onPressed: () {},
                    //       icon: Icon(
                    //         Icons.arrow_forward_ios,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                );
              } else {
                return Center(
                  child: Text("Something went Wrong!"),
                );
              }
            }),
      ),
      bottomSheet: DraggableScrollableSheet(
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: ListView(
                physics: const PageScrollPhysics(),
                controller: scrollController,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(user.photoURL!),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "${widget.views.toString()} Views",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      widget.topic,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(builder: (context, snapshot) {
                    if (_cardData.length == 0) {
                      return Text("");
                    } else if (_cardData.length != 0) {
                      return Text(
                        _cardData[0]["content"],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      );
                    } else {
                      return Text("Oops! Something went wrong!");
                    }
                  })
                ],
              ),
            ),
          );
        },
        maxChildSize: 0.4,
        minChildSize: 0.16,
        initialChildSize: 0.16,
        expand: false,
      ),
    );
  }
}

class SavedCardWidget extends StatelessWidget {
  const SavedCardWidget(
      {required this.index, required this.text, required this.bgImage});

  final int index;
  final String text;
  final String bgImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(bgImage),
                fit: BoxFit.cover,
              ),
            ),
            child: ClipRRect(
              // make sure we apply clip it properly
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: (this.index != 0) ? 4 : 0,
                    sigmaY: (this.index != 0) ? 4 : 0),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 4.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xffFDDEE3),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    this.text,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: (MediaQuery.of(context).size.height / 4.5) + 230,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffFBFDFD).withOpacity(.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                "${index + 1}/${_cardData.length}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Positioned(
          top: (MediaQuery.of(context).size.height / 4.5) + 270,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 10,
            child: Center(
              child: ListView.builder(
                itemBuilder: (BuildContext context, i) {
                  return IndicatorDot(centre: i == index ? true : false);
                },
                itemCount: _cardData.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class IndicatorDot extends StatelessWidget {
  const IndicatorDot({required this.centre});

  final bool centre;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          height: 8,
          width: centre ? 30 : 8,
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }
}

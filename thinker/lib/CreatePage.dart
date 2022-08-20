import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thinker/HomePage.dart';
import 'package:thinker/utils/TempImages.dart';

class CreateCardPage extends StatefulWidget {
  const CreateCardPage({Key? key}) : super(key: key);

  @override
  State<CreateCardPage> createState() => _CreateCardPageState();
}

class _CreateCardPageState extends State<CreateCardPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _topic = "";
  var _topicTemp = "";
  var _clicked = false;
  var _responseData = [];
  final myController = TextEditingController();

  Future _createCard() async {
    if (_topic != "") {
      final SharedPreferences prefs = await _prefs;
      final access_token = prefs.getString("access_token");
      var client = http.Client();
      var response = await client.get(
          Uri.parse(
              'https://thinkerr.herokuapp.com/deck/get_card_data?topic=${_topic}'),
          headers: {
            HttpHeaders.authorizationHeader: 'Basic ${access_token}',
          });
      var _responseDataTemp = jsonDecode(response.body);
      print(_responseDataTemp);
      if (_responseDataTemp["data"] != null) {
        _responseData = _responseDataTemp["data"];
      } else {
        _responseData = [];
      }
      _topicTemp = _topic;
      _topic = "";
    }
  }

  Future _saveCards() async {
    final SharedPreferences prefs = await _prefs;
    final access_token = prefs.getString("access_token");
    var client = http.Client();
    List Cards = [];
    for (int i = 0; i < _responseData.length; i++) {
      Cards.add({"content": _responseData[i]});
    }
    var rng = Random();
    Map body = {
      "topic": _topic,
      "image": ImagesTemp[rng.nextInt(10)],
      "cards": Cards
    };
    print(jsonEncode(body));
    var response = await client.post(
        Uri.parse("https://thinkerr.herokuapp.com/deck/create/"),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic ${access_token}',
          "Content-type": "application/json",
        },
        body: jsonEncode(body));
    print(jsonDecode(response.body));
    return (jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    print(_topic);
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Card"),
        centerTitle: true,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: myController,
              decoration: InputDecoration(
                labelText: "Write you topic here",
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
              ),
              onChanged: (text) {
                _topic = text;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(50)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _clicked = true;
                    });
                  },
                  child: Text(
                    "Create Cards",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _clicked
              ? Container(
                  height: MediaQuery.of(context).size.height - 250,
                  child: FutureBuilder(
                      future: _createCard(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Please Keep patience! Our Artificial Intelligence is on Work to get you great contents!",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                CircularProgressIndicator(),
                              ],
                            ),
                          );
                        } else {
                          return ListView.builder(
                              itemCount: _responseData.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index < _responseData.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100,
                                        decoration: BoxDecoration(
                                          color: Color(0xffFDDEE3),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            child: Text(
                                              _responseData[index],
                                              style: TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 30),
                                    child: InkWell(
                                      onTap: () {
                                        _saveCards().then((data) {
                                          print(data);
                                          if (data["code"] == 200) {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        HomePage()),
                                                (Route<dynamic> route) =>
                                                    false);
                                          }
                                        });
                                      },
                                      child: (_responseData.length != 0)
                                          ? Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Confirm & Save",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 100),
                                                  child: Text(
                                                      "Oops, We Didn't find Anything !"),
                                                ),
                                              ),
                                            ),
                                    ),
                                  );
                                }
                              });
                        }
                      }),
                )
              : Center(
                  child: Text(""),
                )
        ],
      ),
    );
  }
}

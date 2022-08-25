import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thinker/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:thinker/utils/TempImages.dart';

class CreateCardPage extends StatefulWidget {
  @override
  State<CreateCardPage> createState() => _CreateCardPageState();
}

class _CreateCardPageState extends State<CreateCardPage> {
  late Future _fetchCards;
  final TextEditingController controller = new TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _topic = "";
  var _topicTemp = "";
  var _clicked = false;
  var _responseData = [];
  final myController = TextEditingController();

  Future _createCard() async {
    print(_topic);
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

  Future _saveCards(BuildContext context) async {
    // print(_topicTemp);
    final SharedPreferences prefs = await _prefs;
    final access_token = prefs.getString("access_token");
    var client = http.Client();
    List Cards = [];
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
    // for (int i = 0; i < _controllers.length; i++) {
    //   // Cards.add({"content": _responseData[i]});
    //   print(_controllers[i].text);
    // }
    for (int i = 0; i < _responseData.length; i++) {
      Cards.add({"content": _responseData[i]});
      // print(_controllers[i].text);
    }
    // print(_topic);
    var rng = Random();
    Map body = {
      "topic": _topicTemp,
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
    var data = jsonDecode(response.body);
    print(data);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueAccent,
        content: Text(
          "Deck Created Successfully!",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    Navigator.of(context).pop();
    return (jsonDecode(response.body));
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchCards = _createCard();
  // }

  @override
  Widget build(BuildContext context) {
    // print(_topic);
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
                                            // child: TextField(
                                            //   controller: controller,
                                            //   maxLength: 255,
                                            //   maxLines: 5,
                                            // )
                                            child: Container(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 16),
                                                  child: Text(
                                                    _responseData[index],
                                                    style: TextStyle(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
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
                                        _saveCards(context).then((data) {
                                          print(data);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          HomePage()),
                                              (Route<dynamic> route) => false);
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

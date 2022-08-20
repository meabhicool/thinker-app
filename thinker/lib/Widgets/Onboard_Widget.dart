import 'package:flutter/material.dart';
import 'package:thinker/onboarding_screen.dart';

class OnBoard_Widget extends StatelessWidget {
  const OnBoard_Widget(this.index, this.title, this.paragraph);
  final int index;
  final String title;
  final String paragraph;

  widget(int i) {
    if (i == 0) {
      return screen_01_image();
    } else if (i == 1) {
      return screen_02_image();
    } else {
      return screen_03_image();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: widget(index),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    color: (this.index == 0)
                        ? Color(0xff222831)
                        : Color(0xff222831).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    color: (this.index == 1)
                        ? Color(0xff222831)
                        : Color(0xff222831).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    color: (this.index == 2)
                        ? Color(0xff222831)
                        : Color(0xff222831).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            this.title,
            style: TextStyle(
              fontSize: 30,
              color: Color(0xff222831),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
            child: Text(
              this.paragraph,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}

class screen_01_image extends StatelessWidget {
  const screen_01_image({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 400,
      child: Stack(
        children: [
          Positioned(
            child: Image.asset(
              "assets/Card_1.png",
              width: MediaQuery.of(context).size.width,
              height: 300,
            ),
            top: 0,
            right: 50,
            left: -100,
          ),
          Positioned(
            child: Image.asset(
              "assets/Card_3.png",
              width: MediaQuery.of(context).size.width,
              height: 300,
            ),
            top: 60,
            right: 40,
          ),
          Positioned(
            child: Image.asset(
              "assets/Card_2.png",
              width: MediaQuery.of(context).size.width,
              height: 300,
            ),
            top: 140,
            right: 20,
          )
        ],
      ),
    );
  }
}

class screen_02_image extends StatelessWidget {
  const screen_02_image({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        height: 400,
        child: Image.asset(
          "assets/Screen_02.png",
        ),
      ),
    );
  }
}

class screen_03_image extends StatelessWidget {
  const screen_03_image({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        height: 400,
        child: Image.asset(
          "assets/Screen_03.png",
        ),
      ),
    );
  }
}

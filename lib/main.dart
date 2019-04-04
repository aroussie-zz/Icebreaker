import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<String> questions = [
    "If you could have an endless supply of any food, what would you get?",
    "Hi",
    "Hi test 3!!"
  ];

  List<Color> _backgroundColors = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.purple
  ];

  AnimationController _animationController;
  CurvedAnimation _curvedAnimation;
  Animation<Color> _colorAnimation;
  Tween<Color> _colorTween;
  int _currentColorIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    _colorTween = ColorTween(begin: _backgroundColors[0],
        end: _backgroundColors[0]);

    _colorAnimation = _colorTween
        .animate(_curvedAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: animateToNewColor,
            child: AnimatedBuilder(
              animation: _colorAnimation,
              builder: (_, child) {
                return QuestionPage(UniqueKey(), "", _colorAnimation.value);
              },
            )));

//            child: Stack(
//                children: questions.map((question) {
//
//              if (questions.indexOf(question) < 1) {
//                return AnimatedBuilder(
//                  animation: _colorAnimation,
//                  builder: (_, child) {
//                    return QuestionPage("", _colorAnimation.value);
//                  },
//                );
//              } else {
//                return Container();
//              }
//            }).toList())));
  }

  void animateToNewColor(){
    _colorTween.begin = _colorTween.end;
    _animationController.reset();
    _colorTween.end = generateRandomColor();
    _animationController.forward();
  }


  Color generateRandomColor() {
    int a = Random().nextInt(_backgroundColors.length);
    if (a != _currentColorIndex) {
      _currentColorIndex = a;
      return _backgroundColors[a];
    } else
      return generateRandomColor();
  }
}

class QuestionPage extends StatelessWidget {
  QuestionPage(Key key, this.question, this.backgroundColor) : super(key: key);

  final String question;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            child: Text(
              question,
              textScaleFactor: 3,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}

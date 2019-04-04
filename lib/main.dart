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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
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
  AnimationController _questionAnimationController;
  CurvedAnimation _curvedAnimation;
  Animation<Color> _colorAnimation;
  Animation<double> _questionAnimation;
  Tween<Color> _colorTween;
  int _currentColorIndex = 0;
  final UniqueKey questionKey = UniqueKey();
  String myQuestion;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    _questionAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    _colorTween =
        ColorTween(begin: _backgroundColors[0], end: _backgroundColors[0]);

    _colorAnimation = _colorTween.animate(_curvedAnimation);
    _questionAnimation =
        Tween<double>(begin: 1, end: 0).animate(_questionAnimationController);
    myQuestion = questions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: animateToNewColor,
            child: Stack(fit: StackFit.expand, children: <Widget>[
              AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (_, child) {
                    return Scaffold(
                        backgroundColor: _colorAnimation.value,
                        body: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Align(
                              child: Opacity(
                                opacity: _questionAnimation.value,
                                child: Text(
                                  myQuestion,
                                  textScaleFactor: 3,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )));
                  }),
            ])));
  }

  void animateToNewColor() {
    _colorTween.begin = _colorTween.end;
    _animationController.reset();
    _colorTween.end = generateRandomColor();
    _animationController.forward();
    _questionAnimationController.forward().whenComplete(() {
      myQuestion = questions[1];
      _questionAnimationController.reverse();
    });
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
  QuestionPage(Key key, this.question, this.opacity, this.backgroundColor)
      : super(key: key);

  final String question;
  final Color backgroundColor;
  double opacity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              child: Opacity(
                opacity: opacity,
                child: Text(
                  question,
                  textScaleFactor: 3,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )));
  }
}

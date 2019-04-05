import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<String> _icebreakers = ["Helloooooo"];

  AnimationController _animationController;
  AnimationController _questionAnimationController;
  CurvedAnimation _curvedAnimation;
  Animation<Color> _colorAnimation;
  Animation<double> _questionAnimation;
  Tween<Color> _colorTween;
  int _currentColorIndex = 0;
  int _currentQuestionIndex = 0;
  String myQuestion;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _questionAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    _colorTween = ColorTween(begin: Colors.orange, end: Colors.orange);

    _colorAnimation = _colorTween.animate(_curvedAnimation);
    _questionAnimation =
        Tween<double>(begin: 1, end: 0).animate(_questionAnimationController);

    rootBundle.loadString("assets/questions.json").then((data) {
      _icebreakers.addAll((json.decode(data) as List).map(((element) => element.toString())).toList());
    });

    myQuestion = _icebreakers[0];

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
                                  textScaleFactor: 2,
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
      _currentQuestionIndex++;
      myQuestion = _icebreakers[_currentQuestionIndex];
      _questionAnimationController.reverse();
    });
  }

  Color generateRandomColor() {
    var availableColors = Colors.primaries.sublist(0, 9);
    int a = Random().nextInt(availableColors.length);
    if (a != _currentColorIndex) {
      _currentColorIndex = a;
      return availableColors[a];
    } else
      return generateRandomColor();
  }
}

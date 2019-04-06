import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
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
  List<String> _icebreakers = ["Welcome message"];

  AnimationController _colorAnimationController;
  AnimationController _textAnimationController;
  CurvedAnimation _curvedAnimation;
  Animation<Color> _colorAnimation;
  Animation<double> _questionAnimation;
  Tween<Color> _colorTween;
  int _currentColorIndex = 0;
  int _currentQuestionIndex = 0;
  String _currentQuestion;

  @override
  void initState() {
    super.initState();
    _colorAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _textAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    _curvedAnimation = CurvedAnimation(
        parent: _colorAnimationController, curve: Curves.easeOut);

    _colorTween = ColorTween(begin: Colors.orange, end: Colors.orange);

    _colorAnimation = _colorTween.animate(_curvedAnimation);

    _questionAnimation =
        Tween<double>(begin: 1, end: 0).animate(_textAnimationController);

    rootBundle.loadString("assets/questions.json").then((data) {
      _icebreakers.addAll((json.decode(data) as List)
          .map(((element) => element.toString()))
          .toList());
    });
    _currentQuestion = _icebreakers[0];
  }

  @override
  void dispose() {
    super.dispose();
    _colorAnimationController.dispose();
    _textAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _colorAnimation.value,
        body: GestureDetector(
            onTap: _animateColorAndText,
            child: AnimatedBuilder(
                animation: _colorAnimation,
                builder: (_, child) {
                  return Scaffold(
                      backgroundColor: _colorAnimation.value,
                      body: MyQuestionWidget(
                          questionText: _currentQuestion,
                          controller: _textAnimationController));
                }))
        );
  }

  void _animateColorAndText() {
    //Switch to a different color
    _colorTween.begin = _colorTween.end;
    _colorAnimationController.reset();
    _colorTween.end = _generateRandomColor();
    _colorAnimationController.forward();

    // Fade out the text to change it behind the scene and fade it back in
    _textAnimationController.forward().whenComplete(() {
      //If reached the end of the questions, we start from the beginning again
      _currentQuestionIndex = _currentQuestionIndex == _icebreakers.length - 1
          ? 0
          : _currentQuestionIndex += 1;
      _currentQuestion = _icebreakers[_currentQuestionIndex];
      _textAnimationController.reverse();
    });
  }

  Color _generateRandomColor() {
    var availableColors = Colors.primaries.sublist(0, 9);
    int randomIndex = Random().nextInt(availableColors.length);
    if (randomIndex != _currentColorIndex) {
      _currentColorIndex = randomIndex;
      return availableColors[randomIndex];
    } else
      return _generateRandomColor();
  }
}

class MyQuestionWidget extends StatelessWidget {
  MyQuestionWidget({Key key, this.questionText, this.controller, this.colorController}) {
    questionAnimation = Tween<double>(begin: 1, end: 0).animate(controller);
    colorAnimation = _colorTween.animate(colorController);
  }


  String questionText = "";
  Animation<double> controller;
  Animation<double> colorController;
  Animation<double> questionAnimation;
  Tween<Color> _colorTween = ColorTween(begin: Colors.orange, end: Colors.orange);
  Animation<Color> colorAnimation;


  Widget _buildAnimation(BuildContext context, Widget child) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Opacity(
            opacity: questionAnimation.value,
            child: Text(
              questionText,
              textScaleFactor: 2.5,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: controller, builder: _buildAnimation);
  }
}

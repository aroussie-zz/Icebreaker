import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class Question {
  String question, answer;

  Question({this.question, this.answer});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(question: json['question'], answer: json['correct_answer']);
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  static const String TRIVIA_API_URL = 'https://opentdb.com/api.php?amount=30&category=18&type=boolean';
  List<Question> _questions = [
    Question(
        question:
            "Welcome in a Trivia quizz! Each question can be answer by true or false. "
            "Tap on the screen to display the response of the question, "
            "and do it again to go to the next question! Tap to START",
        answer: "")
  ];

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
    myQuestion = _questions[0].question;

    getQuestions()
        .then((fetchedQuestions) {
        debugPrint("QUestions fetched !! Size: ${fetchedQuestions.length}");
          _questions.addAll(fetchedQuestions);});
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
      myQuestion = HtmlUnescape().convert(_questions[_currentQuestionIndex].question);
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

  Future<List<Question>> getQuestions() async {
    final response = await http.get(TRIVIA_API_URL);
    Iterable list = json.decode(response.body)['results'];
    return list.map((model) => Question.fromJson(model)).toList();
  }
}

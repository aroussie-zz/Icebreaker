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

  AnimationController _animationController;
  CurvedAnimation _curvedAnimation;
  Animation<Offset> _offsetAnimation;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    _offsetAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(-400, 0))
        .animate(_curvedAnimation);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange,
        body: GestureDetector(
            onTap: _startAnimation,
            child: Stack(
                overflow: Overflow.visible,
                children: questions.map((question) {
                  // We only want to display one question at a time
                  //TODO: Might have to still display the second question but with opacity 0 ?
                  if (questions.indexOf(question) < 1) {
                    return AnimatedBuilder(
                        animation: _offsetAnimation,
                        builder: (_, child) {
                          return Transform.translate(
                            offset: _getFlickTransformOffset(),
                            child: child,
                          );
                        },
                        child: QuestionPage(question));
                  } else {
                    return Container();
                  }
                }).toList())));
  }

  Offset _getFlickTransformOffset() {
    return _offsetAnimation.value;
  }

  void _startAnimation() {
    //Start the animation
    _animationController.forward().whenComplete(() {
      setState(() {
        _animationController.reset();
        String question = questions.removeAt(0);
        questions.add(question);
      });
    });
  }
}

class QuestionPage extends StatelessWidget {
  QuestionPage(this.question);

  final String question;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            child: Text(question, textScaleFactor: 3),
          ),
        ));
  }
}

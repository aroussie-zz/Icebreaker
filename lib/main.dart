import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

    _curvedAnimation = CurvedAnimation(parent: _animationController,
        curve: Curves.easeOut);

    _offsetAnimation = Tween<Offset>(
        begin: Offset(0, 0),
        end: Offset(-400, 0)
    ).animate(_curvedAnimation)..addListener(() {
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          overflow: Overflow.visible,
            children: questions.map((question) {
              // We only want to display one question at a time
              //TODO: Might have to still display the second question but with opacity 0 ?
              if (questions.indexOf(question) < 1) {
                return Transform.translate(
                    offset: _getFlickTransformOffset(),
                    child: buildQuestion(question)
                );
              } else {
                return Container();
              }
            }).toList()));
  }

  Widget buildQuestion(String question) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: Center(
            child: Text(
              question,
              textScaleFactor: 2,
            ),
          )),
          Container(
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
              onPressed: () { _startAnimation();},
              child: SizedBox(
                height: 58,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "NEXT",
                    textAlign: TextAlign.center,
                    textScaleFactor: 2.0,
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(29))),
            ),
          ),
        ],
      ),
    );
  }

  Offset _getFlickTransformOffset() {
      return _offsetAnimation.value;
  }

  void _startAnimation() {
    //Start the animation
    _animationController.forward()
        .whenComplete((){
      setState(() {
        _animationController.reset();
        String question = questions.removeAt(0);
        questions.add(question);
      });
    });
  }
}

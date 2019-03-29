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

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  List<String> questions = [
    "If you could have an endless supply of any food, what would you get?"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("IceBreaker"),
        ),
        body: Stack(
      children: questions.map((question) {
        return buildQuestion(question);
    }).toList()));
  }

  Widget buildQuestion(String question) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24,0,24,24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child:
            Center(
              child: Text(
                question,
                textScaleFactor: 2,
              ),
            )),
            Container(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
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
}

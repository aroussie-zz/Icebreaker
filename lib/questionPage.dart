import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class QuestionPage extends StatefulWidget {
  @override
  QuestionState createState() {
    return QuestionState();
  }
}

class QuestionState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0,0,24.0,0),
              child: Center(
                child: Text(
                  "If you could have an endless supply of any food, what would you get?",
                  textScaleFactor: 2,
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24,0,24,24),
              child: RaisedButton(
                child: SizedBox(
                  height: 58,
                  width: double.infinity,
                  child: Center(
                    child: Text("NEXT",
                    textAlign: TextAlign.center,
                    textScaleFactor: 2.0,),
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(29))),
              ),
            ),
          )
        ],
      ),
    );
  }
}

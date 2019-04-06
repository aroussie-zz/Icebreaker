import 'package:flutter/material.dart';

class MyQuestionWidget extends StatelessWidget {
  MyQuestionWidget({Key key, this.question, this.controller})
      : questionAnimation = Tween<double>(begin: 1, end: 0).animate(controller);

  final String question;
  final Animation<double> controller;
  final Animation<double> questionAnimation;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Opacity(
            opacity: questionAnimation.value,
            child: Text(
              question,
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

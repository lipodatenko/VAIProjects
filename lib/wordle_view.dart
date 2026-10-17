import 'package:flutter/material.dart';
import 'wordle.dart';

class WordleView extends StatelessWidget {
  final Wordle wordle;
  const WordleView({super.key, required this.wordle});

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.black87;
    Color borderColor = Colors.white24;

    if (wordle.isCorrectPosition) {
      // Correct letter in correct place -> GREEN
      bgColor = Colors.green.shade700;
      borderColor = Colors.greenAccent;
    } else if (wordle.existsInTarget) {
      // Correct letter in wrong place -> YELLOW
      bgColor = Colors.amber.shade700;
      borderColor = Colors.amberAccent;
    } else if (wordle.doesNotExistInTarget) {
      // Incorrect letter -> RED
      bgColor = Colors.red.shade800;
      borderColor = Colors.redAccent;
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Text(
        wordle.letter,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:roll_the_dice/styled_text.dart';

void main() {
  runApp(const RollTheDiceApp());
}

class RollTheDiceApp extends StatelessWidget {
  const RollTheDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GradientContainer(),
      ),
    );
  }
}

class GradientContainer extends StatefulWidget {
  const GradientContainer({super.key});

  @override
  State<GradientContainer> createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer> {
  final Random _random = Random();
  int _diceNumber = 1;

  void _rollDice() {
    setState(() {
      _diceNumber = _random.nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 33, 5, 109),
            Color.fromARGB(255, 68, 21, 149),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const StyledText('Roll the Dice'),
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/dice-$_diceNumber.png',
              width: 200,
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: _rollDice,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 22),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                backgroundColor: const Color.fromARGB(50, 255, 255, 255),
              ),
              child: const Text('Hodiť kockou'),
            ),
          ],
        ),
      ),
    );
  }
}

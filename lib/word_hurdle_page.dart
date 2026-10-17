import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'hurdle_provider.dart';
import 'wordle_view.dart';
import 'keyboard_view.dart';
import 'helper_functions.dart';

class WordHurdlePage extends StatefulWidget {
  const WordHurdlePage({super.key});

  @override
  State<WordHurdlePage> createState() => _WordHurdlePageState();
}

class _WordHurdlePageState extends State<WordHurdlePage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context, HurdleProvider provider) {
    if (!provider.shouldCheckForAnswer) {
      showMsg(context, 'Word must be 5 letters!');
      return;
    }
    if (!provider.isAValidWord) {
      showMsg(context, 'Word not in dictionary!');
      return;
    }

    provider.checkAnswer();

    if (provider.wins) {
      showResult(
        context,
        title: 'YOU WIN! 🎉',
        message: 'Congratulations! You guessed the word!',
        onPlayAgain: provider.reset,
      );
    } else if (provider.noAttemptsLeft) {
      showResult(
        context,
        title: 'GAME OVER! 😢',
        message: 'The correct word was: ${provider.targetWord}',
        onPlayAgain: provider.reset,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HurdleProvider>();

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          final logicalKey = event.logicalKey;
          if (logicalKey == LogicalKeyboardKey.backspace) {
            provider.deleteLetter();
          } else if (logicalKey == LogicalKeyboardKey.enter) {
            _handleSubmit(context, provider);
          } else {
            final label = event.character;
            if (label != null && RegExp(r'^[a-zA-Z]$').hasMatch(label)) {
              provider.inputLetter(label.toUpperCase());
            }
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
        appBar: AppBar(
          title: const Text('Word Hurdle'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                provider.reset();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 1,
                    ),
                    itemCount: provider.hurdleBoard.length,
                    itemBuilder: (context, index) {
                      final wordle = provider.hurdleBoard[index];
                      return WordleView(wordle: wordle);
                    },
                  ),
                ),
              ),
            ),
            const KeyboardView(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade900,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        provider.deleteLetter();
                      },
                      icon: const Icon(Icons.backspace_outlined),
                      label: const Text('DELETE'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _handleSubmit(context, provider),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('SUBMIT'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hurdle_provider.dart';

const List<String> _row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
const List<String> _row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
const List<String> _row3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

class KeyboardView extends StatelessWidget {
  const KeyboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HurdleProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow1(_row1, provider),
          const SizedBox(height: 6),
          _buildRow2(_row2, provider),
          const SizedBox(height: 6),
          _buildRow3(_row3, provider),
        ],
      ),
    );
  }

  Widget _buildRow1(List<String> keys, HurdleProvider provider) {
    return Row(
      children: keys.map((key) {
        final status = provider.keyStatus[key] ?? LetterStatus.none;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: VirtualKey(
              letter: key,
              status: status,
              onTap: () => provider.inputLetter(key),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRow2(List<String> keys, HurdleProvider provider) {
    return Row(
      children: [
        const SizedBox(width: 14),
        ...keys.map((key) {
          final status = provider.keyStatus[key] ?? LetterStatus.none;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: VirtualKey(
                letter: key,
                status: status,
                onTap: () => provider.inputLetter(key),
              ),
            ),
          );
        }),
        const SizedBox(width: 14),
      ],
    );
  }

  Widget _buildRow3(List<String> keys, HurdleProvider provider) {
    return Row(
      children: [
        const SizedBox(width: 36),
        ...keys.map((key) {
          final status = provider.keyStatus[key] ?? LetterStatus.none;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: VirtualKey(
                letter: key,
                status: status,
                onTap: () => provider.inputLetter(key),
              ),
            ),
          );
        }),
        const SizedBox(width: 36),
      ],
    );
  }
}

class VirtualKey extends StatelessWidget {
  final String letter;
  final LetterStatus status;
  final VoidCallback onTap;

  const VirtualKey({
    super.key,
    required this.letter,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.grey.shade800;
    Color borderColor = Colors.white12;

    switch (status) {
      case LetterStatus.correct:
        bgColor = Colors.green.shade700;
        borderColor = Colors.greenAccent;
        break;
      case LetterStatus.wrongPosition:
        bgColor = Colors.amber.shade700;
        borderColor = Colors.amberAccent;
        break;
      case LetterStatus.incorrect:
        bgColor = Colors.red.shade800;
        borderColor = Colors.redAccent;
        break;
      case LetterStatus.none:
        bgColor = Colors.grey.shade800;
        borderColor = Colors.white24;
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

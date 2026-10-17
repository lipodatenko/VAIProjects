import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart' as words;
import 'wordle.dart';
import 'word_list.dart';

enum LetterStatus { none, correct, wrongPosition, incorrect }

class HurdleProvider extends ChangeNotifier {
  final Random _random = Random();
  List<String> totalWords = [];
  List<String> rowInputs = [];
  List<String> excludedLetters = [];
  Map<String, LetterStatus> keyStatus = {};
  List<Wordle> hurdleBoard = [];
  String targetWord = '';
  int count = 0;
  int index = 0;
  bool wins = false;

  bool get isAValidWord {
    return rowInputs.length == 5;
  }

  bool get shouldCheckForAnswer => rowInputs.length == 5;
  bool get noAttemptsLeft => count == 30;

  void init() {
    final wordSet = words.all
        .where((word) => word.length == 5)
        .map((e) => e.toUpperCase())
        .toSet();
    wordSet.addAll(extra5LetterWords);
    totalWords = wordSet.toList();

    _initKeyStatus();
    generateBoard();
    generateRandomWord();
  }

  void _initKeyStatus() {
    keyStatus.clear();
    for (int i = 65; i <= 90; i++) {
      keyStatus[String.fromCharCode(i)] = LetterStatus.none;
    }
  }

  void generateBoard() {
    hurdleBoard = List.generate(30, (index) => Wordle(letter: ''));
  }

  void generateRandomWord() {
    if (totalWords.isNotEmpty) {
      targetWord = totalWords[_random.nextInt(totalWords.length)];
    } else {
      targetWord = 'FLUTT';
    }
  }

  void inputLetter(String letter) {
    if (rowInputs.length < 5 && index < 30) {
      rowInputs.add(letter);
      hurdleBoard[index] = Wordle(letter: letter);
      index++;
      notifyListeners();
    }
  }

  void deleteLetter() {
    if (rowInputs.isNotEmpty && index > 0) {
      rowInputs.removeLast();
      index--;
      hurdleBoard[index] = Wordle(letter: '');
      notifyListeners();
    }
  }

  void checkAnswer() {
    final inputWord = rowInputs.join('').toUpperCase();
    if (inputWord == targetWord) {
      wins = true;
    }

    final startIndex = index - 5;
    for (int i = 0; i < 5; i++) {
      final currentWordle = hurdleBoard[startIndex + i];
      final letter = currentWordle.letter;

      if (letter == targetWord[i]) {
        // Green: correct position
        currentWordle.isCorrectPosition = true;
        currentWordle.existsInTarget = true;
        keyStatus[letter] = LetterStatus.correct;
      } else if (targetWord.contains(letter)) {
        // Yellow: exists in target but wrong position
        currentWordle.existsInTarget = true;
        if (keyStatus[letter] != LetterStatus.correct) {
          keyStatus[letter] = LetterStatus.wrongPosition;
        }
      } else {
        // Red: does not exist in target
        currentWordle.doesNotExistInTarget = true;
        if (!excludedLetters.contains(letter)) {
          excludedLetters.add(letter);
        }
        if (keyStatus[letter] != LetterStatus.correct &&
            keyStatus[letter] != LetterStatus.wrongPosition) {
          keyStatus[letter] = LetterStatus.incorrect;
        }
      }
    }

    count += 5;
    rowInputs.clear();
    notifyListeners();
  }

  void reset() {
    count = 0;
    index = 0;
    rowInputs.clear();
    excludedLetters.clear();
    _initKeyStatus();
    wins = false;
    generateBoard();
    generateRandomWord();
    notifyListeners();
  }
}

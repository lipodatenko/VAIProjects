class Wordle {
  String letter;
  bool existsInTarget;
  bool doesNotExistInTarget;
  bool isCorrectPosition;

  Wordle({
    required this.letter,
    this.existsInTarget = false,
    this.doesNotExistInTarget = false,
    this.isCorrectPosition = false,
  });
}

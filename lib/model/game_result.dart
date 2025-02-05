import 'package:sudoku/model/game_level_options.dart';

enum GameEndReason {
  completed,
  failed,
}

class GameResult {
  final GameLevel level;
  final int errors;
  final Duration elapsedTime;
  final GameEndReason reason;

  GameResult({
    required this.level,
    required this.errors,
    required this.elapsedTime,
    required this.reason,
  });
}

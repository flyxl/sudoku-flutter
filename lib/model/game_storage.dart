import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'board.dart';
import 'game_level_options.dart';
import 'sudoku_game_model.dart';

class GameSaveData {
  final Board board;
  final int errorCount;
  final Duration elapsedTime;
  final GameLevelOptions levelOptions;
  final int selectedNumber;
  final FocusType focusType;

  GameSaveData({
    required this.board,
    required this.errorCount,
    required this.elapsedTime,
    required this.levelOptions,
    required this.selectedNumber,
    required this.focusType,
  });

  Map<String, dynamic> toJson() => {
        'board': board.toJson(),
        'errorCount': errorCount,
        'elapsedTime': elapsedTime.inSeconds,
        'levelOptions': {
          'level': levelOptions.level.index,
          'size': levelOptions.size,
          'difficulty': levelOptions.difficulty,
        },
        'selectedNumber': selectedNumber,
        'focusType': focusType.index,
      };

  factory GameSaveData.fromJson(Map<String, dynamic> json) {
    return GameSaveData(
      board: Board.fromJson(json['board']),
      errorCount: json['errorCount'],
      elapsedTime: Duration(seconds: json['elapsedTime']),
      levelOptions: GameLevelOptions(
        level: GameLevel.values[json['levelOptions']['level']],
        size: json['levelOptions']['size'],
        difficulty: json['levelOptions']['difficulty'],
      ),
      selectedNumber: json['selectedNumber'],
      focusType: FocusType.values[json['focusType']],
    );
  }
}

class GameStorage {
  static const String _keyPrefix = 'sudoku_save_';

  static String _getKey(GameLevel level) => '$_keyPrefix${level.index}';

  static Future<void> saveGame(GameSaveData data) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getKey(data.levelOptions.level);
    final jsonStr = jsonEncode(data.toJson());
    await prefs.setString(key, jsonStr);
  }

  static Future<GameSaveData?> loadGame(GameLevel level) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getKey(level);
    final jsonStr = prefs.getString(key);
    if (jsonStr == null) return null;

    try {
      final json = jsonDecode(jsonStr);
      return GameSaveData.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearSave(GameLevel level) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getKey(level);
    await prefs.remove(key);
  }
}

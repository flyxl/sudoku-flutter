import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sudoku/model/game_result.dart';
import 'package:sudoku/model/game_storage.dart';
import 'package:sudoku/model/sudoku_generator.dart';
import 'package:sudoku/util/app_settings.dart';

import 'board.dart';
import 'cell.dart';
import 'game_level_options.dart';

enum FocusType {
  none,
  board,
  numberSelector,
  eraser,
}

typedef PuzzleSolvedCallback = void Function(GameResult result);

class SudokuGameModel extends ChangeNotifier {
  Board board;
  int _selectedNumber = -1;
  int _errors = 0;
  int _maxErrors = 3;
  bool _isGameOver = false;
  FocusType focusType = FocusType.none;
  Cell? _currentSelectedCell;
  final generator = SudokuGenerator();
  final List<Cell> operations = [];
  final PuzzleSolvedCallback onPuzzleSolved;
  final GameLevelOptions levelOptions;
  Duration _elapsedTime = Duration.zero;

  SudokuGameModel({required this.levelOptions, required this.onPuzzleSolved})
      : board = Board(size: levelOptions.size) {
    _loadOrInitGame();
  }

  Future<void> _loadOrInitGame() async {
    final savedGame = await GameStorage.loadGame(levelOptions.level);
    if (savedGame != null) {
      board = savedGame.board;
      _errors = savedGame.errorCount;
      _elapsedTime = savedGame.elapsedTime;
      _selectedNumber = savedGame.selectedNumber;
      focusType = savedGame.focusType;
      _currentSelectedCell = null;
    } else {
      _init(levelOptions.size, levelOptions.difficulty);
    }
    await initialize();
    notifyListeners();
  }

  void _init(int size, double difficulty) {
    if (difficulty > 1.0 || difficulty < 0.3) {
      difficulty = 0.5;
    }
    var cellsToRemove = (difficulty * size * size).toInt();
    board = generator.generate(size, cellsToRemove);

    _selectedNumber = -1;
    _errors = 0;
    focusType = FocusType.none;
    _currentSelectedCell = null;
    notifyListeners();
  }

  int get selectedNumber => _selectedNumber;
  int get errors => _errors;
  int get maxErrors => _maxErrors;
  bool get isGameOver => _isGameOver;

  void setElapsedTime(Duration elapsedTime) {
    _elapsedTime = elapsedTime;
  }

  void selectNumber(int number) {
    _selectedNumber = number;
    focusType = FocusType.numberSelector;
    notifyListeners();
  }

  bool isNumberSelected(int number) {
    return _selectedNumber == number;
  }

  void selectCell(Cell cell) {
    focusType = FocusType.board;
    _currentSelectedCell = cell;
    notifyListeners();
  }

  void erase() {
    if (_currentSelectedCell != null) {
      if (!_currentSelectedCell!.isInputValid()) {
        _currentSelectedCell!.setInput(0);
        _currentSelectedCell = null;
        _saveGame();
        notifyListeners();
      }
    }
  }

  void rollback() {
    if (operations.isNotEmpty) {
      var lastCell = operations.last;
      lastCell.setInput(0);
      operations.removeLast();
      _currentSelectedCell = null;
      _saveGame();
      notifyListeners();
    }
  }

  void clearSelectCell() {
    _currentSelectedCell = null;
    focusType = FocusType.none;
    notifyListeners();
  }

  Cell? currentSelectedCell() {
    if (focusType != FocusType.board) {
      return null;
    }
    return _currentSelectedCell;
  }

  void fillCell(Cell cell, int value) {
    if (!cell.needInput || cell.input == value) return;

    cell.input = value;
    if (!cell.isInputValid()) {
      _errors++;
      if (_errors >= _maxErrors) {
        _isGameOver = true;
        onPuzzleSolved(GameResult(
          level: levelOptions.level,
          errors: _errors,
          elapsedTime: _elapsedTime,
          reason: GameEndReason.failed,
        ));
      }
    } else if (board.isComplete()) {
      onPuzzleSolved(GameResult(
        level: levelOptions.level,
        errors: _errors,
        elapsedTime: _elapsedTime,
        reason: GameEndReason.completed,
      ));
    }
    notifyListeners();
  }

  void _saveGame() {
    if (!board.isComplete()) {
      final saveData = GameSaveData(
        board: board,
        errorCount: _errors,
        elapsedTime: _elapsedTime,
        levelOptions: levelOptions,
        selectedNumber: _selectedNumber,
        focusType: focusType,
      );
      GameStorage.saveGame(saveData);
    } else {
      GameStorage.clearSave(levelOptions.level);
    }
  }

  bool isInSameBox(Cell cell1, Cell cell2) {
    final size = levelOptions.size;
    final boxRowCount = sqrt(size).toInt();
    final boxColCount = size ~/ boxRowCount;

    final boxRow1 = cell1.row ~/ boxRowCount;
    final boxCol1 = cell1.column ~/ boxColCount;
    final boxRow2 = cell2.row ~/ boxRowCount;
    final boxCol2 = cell2.column ~/ boxColCount;

    return boxRow1 == boxRow2 && boxCol1 == boxCol2;
  }

  int getRemainCount(int number) {
    if (board.size == 0) {
      return levelOptions.size;
    }
    return board.getRemainCount(number);
  }

  Future<void> initialize() async {
    _maxErrors = await AppSettings.getMaxErrors();
    notifyListeners();
  }
}

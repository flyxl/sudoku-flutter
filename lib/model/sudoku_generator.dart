import 'dart:math';

import 'package:sudoku/util/utils.dart';

import 'board.dart';
import 'cell.dart';

class SudokuGenerator {
  bool _dfs(int x, int y, int size, List<List<Cell>> board) {
    if (x == size) {
      return true;
    }
    if (y == size) {
      return _dfs(x + 1, 0, size, board);
    }

    board[x][y].candidates = Set.from(List.generate(size, (i) => i + 1));
    board[x][y]
        .candidates
        .removeWhere((v) => board[x].any((g) => g.value == v));
    board[x][y]
        .candidates
        .removeWhere((v) => board.any((row) => row[y].value == v));
    var box = _getBoxGrids(x, y, size, board);
    board[x][y].candidates.removeWhere((v) => box.any((g) => g.value == v));

    List<int> candidates = board[x][y].candidates.toList()..shuffle();
    for (int v in candidates) {
      board[x][y].value = v;
      board[x][y].input = v;
      if (_dfs(x, y + 1, size, board)) {
        return true;
      }
      board[x][y].value = 0;
      board[x][y].input = 0;
    }
    return false;
  }

  List<Cell> _getBoxGrids(int x, int y, int size, List<List<Cell>> board) {
    int row = x ~/ sqrt(size).toInt() * sqrt(size).toInt();
    int col = y ~/ (size ~/ sqrt(size).toInt());
    List<Cell> res = [];
    for (int i = row; i < row + sqrt(size).toInt(); i++) {
      for (int j = col * (size ~/ sqrt(size).toInt());
          j < (col + 1) * (size ~/ sqrt(size).toInt());
          j++) {
        res.add(board[i][j]);
      }
    }
    return res;
  }

  Board generate(int size, int cellsToRemove) {
    List<List<Cell>> tempBoard = List.generate(
      size,
      (i) => List.generate(
        size,
        (j) => Cell(row: i, column: j, size: size),
        growable: false,
      ),
      growable: false,
    );

    _dfs(0, 0, size, tempBoard);
    _digHoles(cellsToRemove, tempBoard);

    final boardWidth = sqrt(size).toInt();
    final boardHeight = size ~/ boardWidth;

    final board = new Board(size: size);
    for (int boxRow = 0; boxRow < boardHeight; boxRow++) {
      for (int boxCol = 0; boxCol < boardWidth; boxCol++) {
        final box = board.boxes[boxRow][boxCol];
        final boxHeight = box.cells.length;
        final boxWidth = box.cells[0].length;

        for (int cellRow = 0; cellRow < boxHeight; cellRow++) {
          for (int cellCol = 0; cellCol < boxWidth; cellCol++) {
            final globalRow = boxRow * boxHeight + cellRow;
            final globalCol = boxCol * boxWidth + cellCol;
            box.cells[cellRow][cellCol] = tempBoard[globalRow][globalCol];
          }
        }
      }
    }
    print(board);
    return board;
  }

  void _digHoles(int holes, List<List<Cell>> board) {
    final random = Random();
    final size = board.length;
    final indices = List.generate(size * size, (i) => i)..shuffle(random);
    // final result = List.generate(size, (_) => List.filled(size, 0));
    for (final index in indices.take(holes)) {
      final row = index ~/ size;
      final col = index % size;
      final temp = board[row][col];
      temp.input = 0;
      temp.needInput = true;
      if (_countSolutions(board) != 1) {
        temp.input = temp.value;
        temp.needInput = false;
        board[row][col] = temp;
      }
    }
  }

  int _countSolutions(List<List<Cell>> board) {
    final size = board.length;
    var count = 0;
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        if (board[i][j].input == 0) {
          for (var value = 1; value <= size; value++) {
            if (_isValid(i, j, value, board)) {
              board[i][j].input = value;
              count += _countSolutions(board);
              board[i][j].input = 0;
            }
          }
          return count;
        }
      }
    }
    return count + 1;
  }

  bool _isValid(int row, int col, int value, List<List<Cell>> board) {
    final size = board.length;
    int boxRowCount = sqrt(size).toInt();
    int boxColCount = size ~/ boxRowCount;

    for (var i = 0; i < size; i++) {
      // 检查行和列
      if (board[row][i].input == value || board[i][col].input == value) {
        return false;
      }

      // 检查宫
      final boxRow = row ~/ boxRowCount;
      final boxCol = col ~/ boxColCount;
      final rc = boxRCToGlobalRC(boxRow, boxCol, i, boxRowCount, boxColCount);
      if (board[rc[0]][rc[1]].input == value) {
        return false;
      }
    }
    return true;
  }
}

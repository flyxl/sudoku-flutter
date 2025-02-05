import 'dart:math';

import 'box.dart';

class Board {
  // Box矩阵，构成完整的数独棋盘
  final List<List<Box>> boxes;
  final int size;
  final int rows;
  final int columns;

  // 构造函数，初始化一个空的数独棋盘
  Board({
    required this.size,
  })  : columns = sqrt(size).toInt(),
        rows = size ~/ (sqrt(size).toInt()),
        boxes = List.generate(
          size ~/ (sqrt(size).toInt()),
          (row) => List.generate(
            sqrt(size).toInt(),
            (col) => Box(size: size, row: row, column: col),
            growable: false,
          ),
          growable: false,
        );

  // 获取指定位置的Box
  Box getBox(int row, int col) {
    assert(row >= 0 && row < rows && col >= 0 && col < columns);
    return boxes[row][col];
  }

  // 检查整个棋盘是否已完成
  bool isComplete() {
    return boxes.every((row) => row.every((box) => box.isComplete()));
  }

  // 检查整个棋盘是否有效（没有冲突）
  bool isValid() {
    // 检查每一行
    for (int row = 0; row < rows * 3; row++) {
      if (!_isRowValid(row)) return false;
    }

    // 检查每一列
    for (int col = 0; col < columns * 3; col++) {
      if (!_isColumnValid(col)) return false;
    }

    // 检查每个Box
    return boxes.every((row) => row.every((box) => box.isComplete()));
  }

  // 检查指定行是否有效
  bool _isRowValid(int row) {
    final Set<int> numbers = {};
    final boxRow = row ~/ 3;
    final cellRow = row % 3;

    for (int boxCol = 0; boxCol < columns; boxCol++) {
      final box = boxes[boxRow][boxCol];
      for (int cellCol = 0; cellCol < 3; cellCol++) {
        final value = box.cells[cellRow][cellCol].value;
        if (numbers.contains(value)) return false;
        numbers.add(value);
      }
    }
    return true;
  }

  // 检查指定列是否有效
  bool _isColumnValid(int col) {
    final Set<int> numbers = {};
    final boxCol = col ~/ 3;
    final cellCol = col % 3;

    for (int boxRow = 0; boxRow < rows; boxRow++) {
      final box = boxes[boxRow][boxCol];
      for (int cellRow = 0; cellRow < 3; cellRow++) {
        final value = box.cells[cellRow][cellCol].value;
        if (numbers.contains(value)) {
          return false;
        }
        numbers.add(value);
      }
    }
    return true;
  }

  // 获取指定数字还剩下几个没填
  int getRemainCount(int number) {
    if (number < 1 || number > size) {
      return 0;
    }

    int count = 0;
    // 遍历所有Box
    for (var boxRow in boxes) {
      for (var box in boxRow) {
        // 遍历Box中的所有Cell
        for (var cellRow in box.cells) {
          for (var cell in cellRow) {
            // 检查已经正确填入的数字
            if (cell.input == number && cell.isInputValid()) {
              count++;
            }
          }
        }
      }
    }

    return size - count; // 返回还剩下几个没填
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();

    // 遍历每一行的Box
    for (int boxRow = 0; boxRow < rows; boxRow++) {
      // 获取这一行Box的高度（行数）
      int boxHeight = boxes[boxRow][0].cells.length;

      // 遍历Box的每一行cell
      for (int cellRow = 0; cellRow < boxHeight; cellRow++) {
        // 遍历这一行的每个Box
        for (int boxCol = 0; boxCol < columns; boxCol++) {
          Box box = boxes[boxRow][boxCol];
          int boxWidth = box.cells[0].length;

          // 打印Box中的这一行cells
          for (int cellCol = 0; cellCol < boxWidth; cellCol++) {
            int value = box.cells[cellRow][cellCol].value;
            buffer.write(value == 0 ? '.' : value.toString());
            buffer.write(' ');
          }
          // 在Box之间添加分隔符
          if (boxCol < columns - 1) buffer.write('| ');
        }
        buffer.writeln();
      }
      // 在Box行之间添加分隔线
      if (boxRow < rows - 1) {
        buffer.writeln('-' * (size * 2 + columns * 2));
      }
    }

    return buffer.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'rows': rows,
      'columns': columns,
      'boxes':
          boxes.map((row) => row.map((box) => box.toJson()).toList()).toList(),
    };
  }

  factory Board.fromJson(Map<String, dynamic> json) {
    final board = Board(
      size: json['size'],
    );

    final boxesJson = json['boxes'] as List;
    for (int i = 0; i < board.rows; i++) {
      for (int j = 0; j < board.columns; j++) {
        board.boxes[i][j] = Box.fromJson(boxesJson[i][j]);
      }
    }

    return board;
  }
}

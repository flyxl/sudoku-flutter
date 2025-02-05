import 'dart:math';

import 'package:sudoku/model/cell.dart';

class Box {
  final int size; // 整个数独的大小（例如6表示六宫格）
  final int row; // 宫在棋盘中的行索引
  final int column; // 宫在棋盘中的列索引
  final List<List<Cell>> cells; // 宫内的单元格

  Box({
    required this.size,
    required this.row,
    required this.column,
  }) : cells = List.generate(
          _getBoxHeight(size),
          (i) => List.generate(
            _getBoxWidth(size),
            (j) => Cell(
              row: i,
              column: j,
              size: size,
            ),
            growable: false,
          ),
          growable: false,
        );

  // 获取指定位置的单元格
  Cell getCell(int row, int col) {
    assert(row >= 0 &&
        row < _getBoxHeight(size) &&
        col >= 0 &&
        col < _getBoxWidth(size));
    return cells[row][col];
  }

  // 获取Box的高度（行数）
  static int _getBoxHeight(int size) {
    return sqrt(size).toInt();
  }

  // 获取Box的宽度（列数）
  static int _getBoxWidth(int size) {
    final cellRowCount = sqrt(size).toInt();
    final boxColCount = size ~/ cellRowCount;
    return boxColCount;
  }

  // 检查宫是否已完成（所有格子都填入了正确的数字）
  bool isComplete() {
    for (var row in cells) {
      for (var cell in row) {
        if (!cell.isInputValid()) {
          return false;
        }
      }
    }
    return true;
  }

  // 将Box对象转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'row': row,
      'column': column,
      'cells': cells
          .map((row) => row.map((cell) => cell.toJson()).toList())
          .toList(),
    };
  }

  // 从JSON数据创建Box对象
  factory Box.fromJson(Map<String, dynamic> json) {
    final box = Box(
      size: json['size'],
      row: json['row'],
      column: json['column'],
    );

    final cellsJson = json['cells'] as List;
    for (int i = 0; i < box.cells.length; i++) {
      for (int j = 0; j < box.cells[i].length; j++) {
        box.cells[i][j] = Cell.fromJson(cellsJson[i][j]);
      }
    }

    return box;
  }

  // 检查宫是否有效（没有重复数字）
  bool isValid() {
    final Set<int> numbers = {};
    for (var row in cells) {
      for (var cell in row) {
        final value = cell.value;
        if (value != 0) {
          if (numbers.contains(value)) {
            return false;
          }
          numbers.add(value);
        }
      }
    }
    return true;
  }
}

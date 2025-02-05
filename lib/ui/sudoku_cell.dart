import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/model/sudoku_game_model.dart';
import 'package:sudoku/ui/constants.dart';

import '../model/cell.dart';

class SudokuCell extends StatelessWidget {
  final Cell data;

  SudokuCell({
    required this.data,
  });

  bool get isSelected => false;

  @override
  Widget build(BuildContext context) {
    return Consumer<SudokuGameModel>(builder: (context, gameModel, child) {
      Cell? selectedCell = gameModel.currentSelectedCell();
      Color bgColor = Colors.white;
      // 高亮显示
      if (selectedCell == data || data.input == gameModel.selectedNumber) {
        bgColor = SELECTED_CELL_BG_COLOR;
      } else if (selectedCell != null) {
        if (selectedCell.row == data.row ||
            selectedCell.column == data.column ||
            gameModel.isInSameBox(selectedCell, data)) {
          bgColor = RELATED_CELL_BG_COLOR;
        }
      }
      final input = data.input == 0 ? '' : '${data.input}';
      final inputColor = data.needInput
          ? (data.isInputValid() ? INPUT_COLOR : INVALID_NUMBER_COLOR)
          : MAIN_FONT_COLOR;
      return InkWell(
        onTap: () {
          if (data.isInputValid()) {
            // 该格子已经被填入正确的数字，不允许再编辑
            return;
          }

          var value = gameModel.selectedNumber;
          if (value == -1) {
            gameModel.selectCell(data);
          } else {
            gameModel.fillCell(data, value);
          }
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
          ),
          child: Text(
            '$input',
            style: TextStyle(
              fontSize: 28.0,
              color: inputColor,
            ),
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/model/sudoku_game_model.dart';

import 'constants.dart';

class NumberSelectorBtn extends StatefulWidget {
  final int number;
  final double width;
  final double elevation;

  NumberSelectorBtn({required this.number, required this.width, required this.elevation}) : super();

  @override
  _NumberSelectorBtnState createState() => _NumberSelectorBtnState();
}

class _NumberSelectorBtnState extends State<NumberSelectorBtn> {

  @override
  Widget build(BuildContext context) {
    var btn = context.widget as NumberSelectorBtn;
    final width = btn.width;
    final number = btn.number;
    final elevation = btn.elevation;
    return Consumer<SudokuGameModel>(builder: (context, gameModel, child) {
      final selected = gameModel.isNumberSelected(number);
      var remainingCount = gameModel.getRemainCount(btn.number);
      if (remainingCount <= 0) {
        // nsModel.selectNumber(-1);
        return SizedBox(width: width);
      }
      return GestureDetector(
        onTap: () {
          // 用户选择数字后将表盘失焦
          gameModel.clearSelectCell();
          gameModel.selectNumber(number);
        },
        child: Card(
          elevation: selected ? elevation : 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(elevation * 2.0),
          ),
          child: Container(
            width: width,
            height: gameModel.levelOptions.size == 6 ? 72.0 : 60.0,
            alignment: Alignment.center,
            foregroundDecoration: BoxDecoration(
              color: Colors.white.withOpacity(selected ? 0.0 : 0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: INPUT_COLOR,
                  ),
                ),
                SizedBox(height: elevation),
                Text(
                  '$remainingCount',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

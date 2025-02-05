import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/model/sudoku_game_model.dart';
import 'package:sudoku/ui/sudoku_box.dart';
import 'package:sudoku/util/utils.dart';

class SudokuBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SudokuGameModel>(builder: (context, model, child) {
      final board = model.board;
      final size = model.levelOptions.size;
      final boardHeight = board.boxes.length;
      final boardWidth = board.boxes[0].length;

      return Container(
        padding: EdgeInsets.all(rpx(context, 4.0)),
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: boardWidth,
          crossAxisSpacing: rpx(context, 4.0),
          mainAxisSpacing: rpx(context, 4.0),
          childAspectRatio: boardHeight / boardWidth,
          children: List.generate(size, (index) {
            var row = index ~/ boardWidth;
            var column = index % boardWidth;
            var box = board.getBox(row, column);
            return SudokuBox(box: box);
          }),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:sudoku/ui/sudoku_cell.dart';
import '../model/box.dart';
import '../util/utils.dart';

class SudokuBox extends StatelessWidget {
  final Box box;

  const SudokuBox({
    Key? key,
    required this.box,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boxWidth = box.cells[0].length;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: boxWidth,
        crossAxisSpacing: rpx(context, 2.0),
        mainAxisSpacing: rpx(context, 2.0),
        children: List.generate(
          box.cells.length * boxWidth,
          (index) {
            final row = index ~/ boxWidth;
            final col = index % boxWidth;
            final cell = box.getCell(row, col);
            return SudokuCell(data: cell);
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/model/sudoku_game_model.dart';
import 'package:sudoku/ui/number_selector_btn.dart';

class NumberSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<SudokuGameModel>(context, listen: false);

    final size = model.levelOptions.size;
    double elevation = size == 6 ? 4.0 : 2.0;
    final dw = MediaQuery.of(context).size.width;
    double width = ((dw - 16) ~/ size * 0.8).toDouble() - elevation / 4.0;
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
            size,
            (index) => NumberSelectorBtn(
                  number: index + 1,
                  width: width,
                  elevation: elevation,
                )),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/model/sudoku_game_model.dart';

class EraserBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: FaIcon(FontAwesomeIcons.eraser),
        onPressed: () {
          var model = Provider.of<SudokuGameModel>(context, listen: false);
          model.erase();
        });
  }
}

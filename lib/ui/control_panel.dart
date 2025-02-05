import 'package:flutter/material.dart';
import 'package:sudoku/ui/back_btn.dart';
import 'package:sudoku/ui/eraser_btn.dart';

class ControlPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [EraserBtn(), BackBtn()],
    );
  }
}

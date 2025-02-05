import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/model/sudoku_game_model.dart';
import 'package:sudoku/ui/constants.dart';
import 'package:sudoku/util/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const ONE_SECOND = const Duration(seconds: 1);

const STATUS_BAR_FONT_STYLE = TextStyle(
  fontSize: 14.0,
  color: MAIN_FONT_COLOR,
);

class StatusBar extends StatefulWidget {
  final String title;
  StatusBar(this.title);

  @override
  _StatusBarState createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  late Timer _timer;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Start a timer that updates the elapsed time every second
    _timer = Timer.periodic(ONE_SECOND, (timer) {
      setState(() {
        _elapsedTime += Duration(seconds: 1);
        Provider.of<SudokuGameModel>(context, listen: false)
            .setElapsedTime(_elapsedTime);
      });
    });
  }

  @override
  void dispose() {
    // Stop the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedElapsedTime = formatElapsedTime(_elapsedTime);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Consumer<SudokuGameModel>(builder: (context, model, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${model.errors}/${model.maxErrors}',
                style: STATUS_BAR_FONT_STYLE),
            Text(widget.title, style: STATUS_BAR_FONT_STYLE),
            Text('$formattedElapsedTime', style: STATUS_BAR_FONT_STYLE)
          ],
        );
      }),
    );
  }
}

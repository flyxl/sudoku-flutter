import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/model/game_level_options.dart';
import 'package:sudoku/model/sudoku_game_model.dart';
import 'package:sudoku/ui/control_panel.dart';
import 'package:sudoku/ui/number_selector.dart';
import 'package:sudoku/ui/status_bar.dart';
import 'package:sudoku/ui/sudoku_board.dart';
import 'package:sudoku/util/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SudokuGamePage extends StatelessWidget {
  final GameLevelOptions gameLevelOptions;

  SudokuGamePage({required this.gameLevelOptions});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SudokuGameModel(
          levelOptions: gameLevelOptions,
          onPuzzleSolved: (result) {
            Navigator.pop(context, result);
          }),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.appTitle),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StatusBar(gameLevelOptions.level.name(context)),
              SizedBox(height: rpx(context, 10.0)),
              SudokuBoard(),
              SizedBox(height: rpx(context, 20.0)),
              ControlPanel(),
              SizedBox(height: rpx(context, 20.0)),
              NumberSelector(),
            ],
          ),
        ),
      ),
    );
  }
}

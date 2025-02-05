import 'package:flutter/material.dart';
import 'package:sudoku/model/game_level_options.dart';
import 'package:sudoku/model/game_result.dart';
import 'package:sudoku/ui/constants.dart';
import 'package:sudoku/ui/new_game_dialog.dart';
import 'package:sudoku/ui/settings_page.dart';
import 'package:sudoku/ui/sudoku_game_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sudoku/util/app_settings.dart';
import 'dart:io';
import 'package:sudoku/util/utils.dart';

const _FONT_STYLE = TextStyle(
  fontSize: 14.0,
  color: MAIN_FONT_COLOR,
);

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameResult? _result;
  String? _backgroundImage;

  @override
  void initState() {
    super.initState();
    _loadRandomImage();
  }

  Future<void> _loadRandomImage() async {
    final imagePath = await AppSettings.getRandomImage();
    setState(() {
      _backgroundImage = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    var image;
    if (_result != null && _result!.reason == GameEndReason.failed) {
      image = Image.asset('res/images/failed.jpg');
    } else {
      image = _backgroundImage != null
          ? Image.file(
              File(_backgroundImage!),
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            )
          : Image.asset('res/images/thumbs-up.jpg');
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 80), // 顶部留白
              Expanded(
                flex: 4,
                child: Center(
                  child: image,
                ),
              ),
              _result != null
                  ? Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                              AppLocalizations.of(context)!
                                  .difficulty(_result!.level.name(context)),
                              style: _FONT_STYLE),
                          Text(
                              AppLocalizations.of(context)!
                                  .mistakes(_result!.errors),
                              style: _FONT_STYLE),
                          Text(
                              AppLocalizations.of(context)!.usedTime(
                                  formatElapsedTime(_result!.elapsedTime)),
                              style: _FONT_STYLE),
                        ],
                      ),
                    )
                  : Expanded(
                      flex: 1,
                      child: Text(AppLocalizations.of(context)!.slogan,
                          style: TextStyle(
                              fontSize: 20.0, color: MAIN_FONT_COLOR)),
                    ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 64.0),
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      GameLevelOptions options = await showModalBottomSheet(
                        context: context,
                        builder: (context) => NewGameDialog(),
                      );
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SudokuGamePage(gameLevelOptions: options),
                        ),
                      );

                      if (!mounted) return;

                      setState(() {
                        _result = result;
                      });
                      _loadRandomImage();
                    },
                    child: Text(AppLocalizations.of(context)!.newGame,
                        style: TextStyle(fontSize: 18.0)),
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(350, 40)),
                      maximumSize:
                          MaterialStateProperty.all<Size>(Size(350, 40)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 80), // 底部留白
            ],
          ),
          Positioned(
            right: 16,
            top: 36,
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                final oldImagePaths = await AppSettings.getImagePaths();
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
                final newImagePaths = await AppSettings.getImagePaths();
                if (oldImagePaths.length != newImagePaths.length ||
                    !oldImagePaths
                        .every((path) => newImagePaths.contains(path))) {
                  _loadRandomImage();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

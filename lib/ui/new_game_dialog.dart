import 'package:flutter/material.dart';
import 'package:sudoku/model/game_level_options.dart';
import 'package:sudoku/model/game_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const GAME_LEVEL_OPTIONS = [
  GameLevelOptions(level: GameLevel.fast, size: 6, difficulty: 0.6),
  GameLevelOptions(level: GameLevel.easy, size: 9, difficulty: 0.3),
  GameLevelOptions(level: GameLevel.medium, size: 9, difficulty: 0.45),
  GameLevelOptions(level: GameLevel.hard, size: 9, difficulty: 0.6),
  GameLevelOptions(level: GameLevel.expert, size: 9, difficulty: 0.8)
];

class NewGameDialog extends StatefulWidget {
  @override
  State<NewGameDialog> createState() => _NewGameDialogState();
}

class _NewGameDialogState extends State<NewGameDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: GAME_LEVEL_OPTIONS.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Center(
              child: Text(GAME_LEVEL_OPTIONS[index].level.name(context)),
            ),
            onTap: () async {
              final level = GAME_LEVEL_OPTIONS[index].level;
              final savedGame = await GameStorage.loadGame(level);

              if (savedGame != null) {
                if (!mounted) return;
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(AppLocalizations.of(context)!.appTitle),
                    content: Text('是否继续上次未完成的游戏？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('继续游戏'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('新游戏'),
                      ),
                    ],
                  ),
                );

                if (result == true) {
                  Navigator.pop(context, GAME_LEVEL_OPTIONS[index]);
                } else {
                  await GameStorage.clearSave(level);
                  Navigator.pop(context, GAME_LEVEL_OPTIONS[index]);
                }
              } else {
                Navigator.pop(context, GAME_LEVEL_OPTIONS[index]);
              }
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum GameLevel {
  fast,
  easy,
  medium,
  hard,
  expert,
}

extension GameLevelExtension on GameLevel {
  String name(BuildContext context) {
    switch (this) {
      case GameLevel.fast:
        return AppLocalizations.of(context)!.fast;
      case GameLevel.easy:
        return AppLocalizations.of(context)!.easy;
      case GameLevel.medium:
        return AppLocalizations.of(context)!.medium;
      case GameLevel.hard:
        return AppLocalizations.of(context)!.hard;
      case GameLevel.expert:
        return AppLocalizations.of(context)!.expert;
      default:
        return '';
    }
  }
}

class GameLevelOptions {
  final GameLevel level;
  final int size;
  final double difficulty;

  const GameLevelOptions({
    required this.level,
    required this.size,
    required this.difficulty,
  });
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

double sw(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double sh(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double st(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}

double rpx(BuildContext context, double val) {
  return sw(context) / 750 * val;
}

void handleForceVertical() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

void push(BuildContext context, Widget wgt) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => wgt));
}

List<int> boxRCToGlobalRC(
    int boxRow, int boxCol, int index, int boxRowCount, int boxColCount) {
  int cellRow = index ~/ boxColCount;
  int cellColumn = index % boxColCount;
  int r = (boxRow * boxRowCount) + cellRow;
  int c = (boxCol * boxColCount) + cellColumn;
  return [r, c];
}

String formatElapsedTime(Duration elapsedTime) {
  final elapsedMinutes = elapsedTime.inMinutes.toString().padLeft(2, '0');
  final elapsedSeconds =
      (elapsedTime.inSeconds % 60).toString().padLeft(2, '0');
  return '$elapsedMinutes:$elapsedSeconds';
}

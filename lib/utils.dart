import 'package:flutter/material.dart';

bool isInText(
    {required Offset clickedPosition,
    required Offset itemPosition,
    required double itemWidth,
    required double itemHeight}) {
  return clickedPosition.dx >= itemPosition.dx &&
      clickedPosition.dx <= itemPosition.dx + itemWidth &&
      clickedPosition.dy >= itemPosition.dy &&
      clickedPosition.dy <= itemPosition.dy + itemHeight;
}

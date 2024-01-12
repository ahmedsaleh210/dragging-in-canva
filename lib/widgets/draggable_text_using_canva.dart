//TODO Using CustomPaint
import 'package:flutter/material.dart';
import 'package:test_project/utils.dart';

class DraggableTextWithCanva extends StatelessWidget {
  const DraggableTextWithCanva({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.grey[200],
      child: const DraggedText(),
    );
  }
}

class DraggedText extends StatefulWidget {
  const DraggedText({super.key});

  @override
  State<DraggedText> createState() => _DraggedTextState();
}

class _DraggedTextState extends State<DraggedText> {
  Offset _position = const Offset(50, 50);
  double _textWidth = 0.0;
  double _textHeight = 0.0;
  bool _isDragging = false;

  static const textSpan = TextSpan(
    text: 'Drag me',
    style: TextStyle(color: Colors.blue, fontSize: 30),
  );
  final _textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );

  @override
  Widget build(BuildContext context) {
    _textPainter.layout();
    _textWidth = _textPainter.width;
    _textHeight = _textPainter.height;

    return GestureDetector(
      onPanStart: (details) {
        _isDragging = isInText(
            clickedPosition: details.localPosition,
            itemPosition: _position,
            itemWidth: _textWidth,
            itemHeight: _textHeight);
      },
      onPanUpdate: (details) {
        final currentX = _position.dx + details.delta.dx;
        final currentY = _position.dy + details.delta.dy;
        if (_isDragging) {
          setState(() {
            _position = Offset(
              currentX.clamp(0, 300 - _textWidth),
              currentY.clamp(0, 300 - _textHeight),
            );
          });
        }
      },
      child: CustomPaint(
        painter: CustomTextPainter(_position, textSpan),
      ),
    );
  }
}

class CustomTextPainter extends CustomPainter {
  final Offset position;
  final TextSpan textSpan;

  CustomTextPainter(this.position, this.textSpan);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

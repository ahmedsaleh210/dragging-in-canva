//TODO Using Stack
import 'package:flutter/material.dart';

class DraggableTextWithStack extends StatelessWidget {
  const DraggableTextWithStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 300,
          height: 300,
          color: Colors.grey[200],
        ),
        const DraggedText(),
      ],
    );
  }
}

class DraggedText extends StatefulWidget {
  const DraggedText({super.key});

  @override
  State<DraggedText> createState() => _DraggedTextState();
}

class _DraggedTextState extends State<DraggedText> {
  Offset _position = const Offset(0, 25);
  double _textHeight = 0.0;
  double _textWidth = 0.0;
  final key = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = getRedBoxSize(key.currentContext!);
      _textHeight = size.height;
      _textWidth = size.width;
    });
    super.initState();
  }

  Size getRedBoxSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return box.size;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              final currentX = _position.dx + details.delta.dx;
              final currentY = _position.dy + details.delta.dy;
              debugPrint('$currentY');

              _position = Offset(
                currentX.clamp(0, 300 - _textWidth),
                currentY.clamp(0, 300 - _textHeight),
              );
            });
          },
          child: Text(
            key: key,
            'Drag me',
            style: const TextStyle(color: Colors.blue, fontSize: 30),
          )),
    );
  }
}

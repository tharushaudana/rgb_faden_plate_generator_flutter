import 'package:flutter/material.dart';
import 'package:rgb_faded_plate_generator/components/colorplateviewer/platepainter.dart';

class ColorPlateViewer extends StatefulWidget {
  const ColorPlateViewer({super.key, required this.plate});

  final List<List<Color>> plate;

  @override
  State<StatefulWidget> createState() => _ColorPlateViewerState();
}

class _ColorPlateViewerState extends State<ColorPlateViewer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: CustomPaint(
        painter: PlatePainter(plate: widget.plate),
      ),
    );
  }
}

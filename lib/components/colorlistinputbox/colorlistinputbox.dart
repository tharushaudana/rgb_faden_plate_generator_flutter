import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorListInputBox extends StatefulWidget {
  const ColorListInputBox({
    super.key,
    required this.colors,
    required this.onColor,
  });

  final List<Color> colors;
  final Function(Color color) onColor;

  @override
  State<StatefulWidget> createState() => _ColorListInputBoxState();
}

class _ColorListInputBoxState extends State<ColorListInputBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 300,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border.all(
          color: Colors.grey.shade100,
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: ListView.builder(
        itemCount: widget.colors.length + 1,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, i) {
          return ColorInput(
            color: i > widget.colors.length - 1 ? null : widget.colors[i],
            onColor: widget.onColor,
          );
        },
      ),
    );
  }
}

class ColorInput extends StatefulWidget {
  const ColorInput({super.key, required this.color, required this.onColor});

  final Color? color;
  final Function(Color color) onColor;

  @override
  State<StatefulWidget> createState() => _ColorInputState();
}

class _ColorInputState extends State<ColorInput> {
  onTextChanged(String value) {
    if (value.length != 6) return;
    widget.onColor(hexToColor(value));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: widget.color == null ? 78 : 30,
      height: widget.color == null ? 50 : 20,
      margin: EdgeInsets.only(bottom: widget.color == null ? 0 : 5),
      child: widget.color == null
          ? TextField(
              onChanged: (value) {
                onTextChanged(value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "000000",
                counterText: "",
              ),
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Consolas',
              ),
              maxLength: 6,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9a-fA-F]+$')),
              ],
              autofocus: true,
            )
          : Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Center(
                child: Text(
                  colorToHex(widget.color!),
                  style: TextStyle(fontFamily: 'consolas'),
                ),
              ),
            ),
    );
  }
}

Color hexToColor(String hexString) {
  String formattedString = '0xFF' + hexString;
  int colorValue = int.parse(formattedString);
  return Color(colorValue);
}

String colorToHex(Color color) {
  String s = '${color.value.toRadixString(16).padLeft(8, '0')}';
  return s.substring(2);
}

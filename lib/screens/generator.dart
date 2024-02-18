import 'dart:developer';
import 'dart:math' as math;
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:rgb_faded_plate_generator/components/colorlistinputbox/colorlistinputbox.dart';
import 'package:rgb_faded_plate_generator/components/colorplateviewer/colorplateviewer.dart';
import 'package:rgb_faded_plate_generator/components/numericupdown/numericupdown.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key, required this.colors});

  final List<Color> colors;

  @override
  State<StatefulWidget> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  int fadeLen = 16;
  double factorX = 3.0;
  double factorY = 2.0;
  double f1xpos = -1;

  List<List<Color>> plate = [];

  late CodeController _codeController;

  int fadeMode = 0; // 0: darken | 1: lighten | 2: mixed

  double yValue(double x) {
    return math.pow(1 - math.pow(x, factorX), 1 / factorY).toDouble();
  }

  void findFirstly1XPosFrom1To0() {
    double i = 1.0;

    while (i >= 0) {
      double y = double.parse(yValue(i).toStringAsFixed(2));

      if (y == 1.0) {
        setState(() {
          f1xpos = i;
        });

        break;
      }

      i -= 0.01;
    }
  }

  Color fadenColorAtPos(Color leadColor, int pos, {bool lighten = false}) {
    double p = f1xpos + ((pos + 1) / fadeLen) * (1 - f1xpos);
    double v = 1 - yValue(p);

    return lighten
        ? leadColor
            .withRed(math.min(255, leadColor.red + 255 * (1 - v)).toInt())
            .withGreen(math.min(255, leadColor.green + 255 * (1 - v)).toInt())
            .withBlue(math.min(255, leadColor.blue + 255 * (1 - v)).toInt())
        : leadColor
            .withRed((leadColor.red * v).toInt())
            .withGreen((leadColor.green * v).toInt())
            .withBlue((leadColor.blue * v).toInt());
  }

  generatePlate() async {
    plate.clear();

    for (int i = 0; i < widget.colors.length; i++) {
      plate.add([]);
      for (int j = fadeLen - 1; j >= 0; j--) {
        Color c = fadenColorAtPos(
          widget.colors[i],
          j,
          lighten: fadeMode == 1,
        );
        plate[i].add(c);
      }
      if (fadeMode == 2) {
        for (int j = fadeLen - 2; j >= 0; j--) {
          Color c = fadenColorAtPos(
            widget.colors[i],
            j,
            lighten: true,
          );
          plate[i].add(c);
        }
      }
    }

    setState(() {});
  }

  fillCode() {
    String s = "";

    for (var i = 0; i < plate.length; i++) {
      List colors = plate[i];

      s += "// [${colorToHex(colors[0])}]\n";

      for (var color in colors) {
        s += "0x${colorToHex(color)}, ";
      }

      if (i < plate.length - 1) s += "\n";
    }

    _codeController.text = s;
  }

  openCode() {
    fillCode();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Plate Code"),
          content: SingleChildScrollView(
            child: Container(
              width: 400,
              child: CodeField(
                controller: _codeController,
                textStyle: const TextStyle(
                  fontFamily: 'consolas',
                ),
                readOnly: true,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _codeController = CodeController();
    findFirstly1XPosFrom1To0();
    generatePlate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faden Plate"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  NumericUpDown(
                    title: "FACTOR X",
                    width: 150,
                    min: 1.1,
                    max: 1000.0,
                    step: 0.1,
                    initial: 3,
                    onChanged: (value) {
                      factorX = value;
                      findFirstly1XPosFrom1To0();
                      generatePlate();
                    },
                  ),
                  const SizedBox(width: 10),
                  NumericUpDown(
                    title: "FACTOR Y",
                    width: 150,
                    min: 1.0,
                    max: 1000.0,
                    step: 0.1,
                    initial: 2,
                    onChanged: (value) {
                      factorY = value;
                      findFirstly1XPosFrom1To0();
                      generatePlate();
                    },
                  ),
                  const SizedBox(width: 10),
                  NumericUpDown(
                    title: "FADE LENGTH",
                    width: 150,
                    min: 4,
                    max: 64,
                    step: 1,
                    initial: 16,
                    isInt: true,
                    onChanged: (value) {
                      fadeLen = value.toInt();
                      generatePlate();
                    },
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio(
                            groupValue: fadeMode,
                            value: 0,
                            onChanged: (value) {
                              setState(() {
                                fadeMode = value!;
                                generatePlate();
                              });
                            },
                          ),
                          const Text("Darken")
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            groupValue: fadeMode,
                            value: 1,
                            onChanged: (value) {
                              setState(() {
                                fadeMode = value!;
                                generatePlate();
                              });
                            },
                          ),
                          const Text("Lighten")
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            groupValue: fadeMode,
                            value: 2,
                            onChanged: (value) {
                              setState(() {
                                fadeMode = value!;
                                generatePlate();
                              });
                            },
                          ),
                          const Text("Mixed")
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () {
                      openCode();
                    },
                    child: const Text("GET CODE"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: ColorPlateViewer(plate: plate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

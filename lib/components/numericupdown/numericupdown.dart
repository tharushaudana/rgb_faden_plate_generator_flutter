import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class NumericUpDown extends StatefulWidget {
  const NumericUpDown({
    super.key,
    required this.title,
    required this.min,
    required this.max,
    required this.step,
    required this.initial,
    required this.onChanged,
    this.isInt = false,
    this.width = 200,
  });

  final String title;
  final double min;
  final double max;
  final double step;
  final double initial;
  final Function(double value) onChanged;
  final bool isInt;
  final double width;

  @override
  State<StatefulWidget> createState() => _NumericUpDownState();
}

class _NumericUpDownState extends State<NumericUpDown> {
  Timer? timer;
  bool isLoop = false;

  double value = 0;

  setValue(double v) {
    setState(() {
      value = v;
    });
  }

  bool validateValue(double v) {
    v = double.parse(v.toStringAsFixed(1));
    return (v <= widget.max) && (v >= widget.min);
  }

  onClickUp() {
    if (!validateValue(value + widget.step)) return;
    setValue(value + widget.step);
    if (!isLoop) widget.onChanged(value);
  }

  onClickDown() {
    if (!validateValue(value - widget.step)) return;
    setValue(value - widget.step);
    if (!isLoop) widget.onChanged(value);
  }

  onTextEditedByUser(String text) {
    double? v = double.tryParse(text);

    if (v == null) {
      setValue(value);
      return;
    }

    if (!validateValue(v)) return;

    setValue(v);
  }

  @override
  void initState() {
    super.initState();
    setValue(widget.initial);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 50,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  !widget.isInt
                      ? value.toStringAsFixed(1)
                      : value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 23,
                    fontFamily: 'Consolas',
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    onClickUp();
                  },
                  onLongPress: () {
                    isLoop = true;
                    timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
                      onClickUp();
                    });
                  },
                  onLongPressEnd: (details) {
                    isLoop = false;
                    timer?.cancel();
                    widget.onChanged(value);
                  },
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_drop_up,
                        color: Colors.white70,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    onClickDown();
                  },
                  onLongPress: () {
                    isLoop = true;
                    timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
                      onClickDown();
                    });
                  },
                  onLongPressEnd: (details) {
                    isLoop = false;
                    timer?.cancel();
                    widget.onChanged(value);
                  },
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white70,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

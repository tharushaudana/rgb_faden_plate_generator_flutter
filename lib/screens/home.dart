import 'package:flutter/material.dart';
import 'package:rgb_faded_plate_generator/components/colorlistinputbox/colorlistinputbox.dart';
import 'package:rgb_faded_plate_generator/screens/generator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  List<Color> colors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RGB Faden Plate Generator"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ADD COLORS",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 20,
              ),
              child: ColorListInputBox(
                colors: colors,
                onColor: (color) {
                  if (colors.contains(color)) return;

                  setState(() {
                    colors.add(color);
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      colors.clear();
                    });
                  },
                  child: Text("CLEAR"),
                ),
                const SizedBox(width: 15),
                FilledButton(
                  onPressed: colors.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GeneratorScreen(
                                colors: colors,
                              ),
                            ),
                          );
                        },
                  child: Text("GENERATE"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

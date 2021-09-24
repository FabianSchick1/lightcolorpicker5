import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightcolorpicker/components/function_button.dart';

class FunctionScreen extends StatefulWidget {
  // ignore: deprecated_member_use
  @override
  _State createState() => _State();
}

class _State extends State<FunctionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Functions"),
          centerTitle: true,
        ),
        body: Container(
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              FunctionButton("Rainbow"),
              FunctionButton("Alarm"),
              FunctionButton("Licht Heller"),
              FunctionButton("Licht Dunkler"),
              FunctionButton("Lampe Langsam an"),
              FunctionButton("Transistion"),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lightcolorpicker/constants.dart';
import 'package:lightcolorpicker/database/lamp.dart';
import 'package:lightcolorpicker/technology/udp.dart';

class FunctionButton extends StatefulWidget {
  String modus = "";

  FunctionButton(String modus) {
    this.modus = modus;
  }

  @override
  _FunctionButtonState createState() => _FunctionButtonState();
}

class _FunctionButtonState extends State<FunctionButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Funktion ausführen
      onTap: () async {
        Lamp lamp;
        var lamps = [];
        for (int index = 0; index < Hive.box('lamps').values.length; index++) {
          lamp = Hive.box('lamps').getAt(index) as Lamp;
          if (lamp.lampSelected) {
            print("$lamp $index");
            lamps.add(lamp);
          }
        }

        Udp connection = Udp();
        lamps.forEach((lamp) {
          setState(() {
            lamp.modus = widget.modus;
            connection.sendFunctionToLamp(
              lampIp1: lamp.lampIp1,
              lampIp2: lamp.lampIp2,
              lampIp3: lamp.lampIp3,
              modus: widget.modus.toLowerCase(),
            );
          });
        });
      },
      // Einstellungen aufrufen
      onLongPress: () {},
      child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          margin: EdgeInsets.all(18.0),
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              widget.modus,
              textAlign: TextAlign.center,
              style: kCustomTextFont.copyWith(fontSize: 25.0),
            ),
          )),
    );
  }
}

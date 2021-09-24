import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:lightcolorpicker/constants.dart';
import 'package:lightcolorpicker/database/lamp.dart';

class AddLampGroupScreen extends StatefulWidget {
  @override
  _AddLampGroupScreenState createState() => _AddLampGroupScreenState();
}

class _AddLampGroupScreenState extends State<AddLampGroupScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextFormField oder TextField
  TextEditingController nameInputCT = TextEditingController();
  TextEditingController ip1InputCT = TextEditingController();
  TextEditingController ip2InputCT = TextEditingController();
  TextEditingController ip3InputCT = TextEditingController();
  TextEditingController wwInputCT = TextEditingController();

  // Lamp-Variables
  String _lampName;
  String _lampIp;
  String _lampIp2;
  String _lampIp3;
  bool _lampWW;

  // add
  void addLamp(Lamp lamp) {
    final lampsBox = Hive.box('lamps');
    lampsBox.add(lamp);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40.0),
        topRight: Radius.circular(40.0),
      ),
      child: Form(
        key: _formKey,
        child: Container(
          color: Colors.grey[800],
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Add new Lamp!",
                style: kCustomTextFont.copyWith(fontSize: 25.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                indent: 40.0,
                endIndent: 40.0,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      // Lampe Name
                      SizedBox(
                        width: 40.0,
                      ),
                      SizedBox(
                        width: 120.0,
                        child: Text(
                          "Lamp-Name: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: nameInputCT,
                          onChanged: (value) {
                            _lampName = value.trim();
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Lamp-Name",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                    ],
                  ),
                  Divider(
                    indent: 100.0,
                    endIndent: 100.0,
                  ),
                  // Lamp Ip
                  Row(
                    children: [
                      SizedBox(
                        width: 40.0,
                      ),
                      SizedBox(
                        width: 120.0,
                        child: Text(
                          "First Lamp-IP: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: ip1InputCT,
                          onChanged: (value) {
                            _lampIp = value.trim();
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Lamp-IP",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                    ],
                  ),
                  Divider(
                    indent: 100.0,
                    endIndent: 100.0,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40.0,
                      ),
                      SizedBox(
                        width: 120.0,
                        child: Text(
                          "Second Lamp-IP: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: ip2InputCT,
                          onChanged: (value) {
                            _lampIp2 = value.trim();
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Lamp-IP",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                    ],
                  ),
                  Divider(
                    indent: 100.0,
                    endIndent: 100.0,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40.0,
                      ),
                      SizedBox(
                        width: 120.0,
                        child: Text(
                          "Third Lamp-IP: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: ip3InputCT,
                          onChanged: (value) {
                            _lampIp3 = value.trim();
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Lamp-IP",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                    ],
                  ),
                  Divider(
                    indent: 100.0,
                    endIndent: 100.0,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40.0,
                      ),
                      SizedBox(
                        width: 120.0,
                        child: Text(
                          "Lamp-WW: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: wwInputCT,
                          onChanged: (boolAsString) {
                            _lampWW = boolAsString.toLowerCase() == "true";
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Lamp-WW",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                    ],
                  ),
                  Divider(
                    indent: 100.0,
                    endIndent: 100.0,
                  ),
                  // Lamp Port
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // default value rgb und height == null
                  // ignore: deprecated_member_use
                  RaisedButton(
                    color: Colors.grey[800],
                    padding: EdgeInsets.all(20.0),
                    onPressed: () {
                      if (_lampName.isNotEmpty && _lampName is String) {
                        if (_lampIp.isNotEmpty && _lampIp is String) {
                          // Add-Lampen:
                          _formKey.currentState.save();
                          // Standard Werte reintun, die nicht immer anders sein müssen.
                          final newLamp = Lamp(
                            lampName: _lampName,
                            lampIp1: _lampIp,
                            brightPerc: 1.0,
                            isLampFirstClick: true,
                            lampOn: false,
                            lampRgbColor: "157,158,158",
                            lampSelected: false,
                            lampSelectColor: "158,158,158",
                            lampIconColor: "158,158,158",
                            lampSelectButtonColor: "97,97,97",
                            lampWW: _lampWW,
                            modus: "Select",
                            lampIp2: _lampIp2,
                            lampIp3: _lampIp3,
                          );

                          addLamp(newLamp);
                          Navigator.pop(context);
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.grey)),
                    child: Row(
                      children: [
                        SizedBox(width: 60.0),
                        Text(
                          "Add Lamp-Group!",
                          style: kCustomTextFont.copyWith(fontSize: 20.0),
                        ),
                        SizedBox(
                          width: 60.0,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

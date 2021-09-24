import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:color_models/color_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:lightcolorpicker/components/lamp_switch.dart';
import 'package:lightcolorpicker/constants.dart';
import 'package:lightcolorpicker/database/lamp.dart';
import 'package:lightcolorpicker/screens/configure_screen.dart';
import 'package:lightcolorpicker/screens/function_screen.dart';
import 'package:lightcolorpicker/technology/rgb.dart';
import 'package:lightcolorpicker/technology/udp.dart';
import 'package:udp/udp.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Udp connection = Udp();

  // ColorCode-Stuff
  int lampWWValue = 0;
  double brightnessPercentage = 1.0;
  double brightness = 100;
  String currentColor;
  Color pickedColor;

  void lampSelectedColorToWhite() {
    for (int i = 0; i < Hive.box('lamps').length; i++) {
      var lamp = Hive.box('lamps').getAt(i) as Lamp;
      if (lamp.lampSelected) {
        lamp.lampSelectColor = kWhite;
      }
    }
  }

  String hexToRgb(Rgb rgbTech) {
    String currentColor = pickedColor.toString();
    currentColor = currentColor.substring(10, 16);
    String rgbValue = RgbColor.fromHex(currentColor).toString();

    int rValue = rgbTech.changeRgbString(rgbValue)[0];
    int gValue = rgbTech.changeRgbString(rgbValue)[1];
    int bValue = rgbTech.changeRgbString(rgbValue)[2];
    rgbValue = "$rValue, $gValue, $bValue";

    return rgbValue;
  }

  // Colorpicker-Stuff #NoPlan
  String imagePath = "images/colorpicker.png";
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();
  bool useSnapshot = true;
  GlobalKey currentKey;
  final StreamController<Color> _stateController = StreamController<Color>();
  img.Image photo;

  bool checkIfInCircle() {
    if (pickedColor.toString() == "Color(0x00000000)") {
      return false;
    } else {
      return true;
    }
  }

  void searchPixel(Offset globalPosition) async {
    if (photo == null) {
      await (useSnapshot ? loadSnapshotBytes() : loadImageBundleBytes());
    }
    _calculatePixel(globalPosition);
  }

  void _calculatePixel(Offset globalPosition) {
    RenderBox box = currentKey.currentContext.findRenderObject();
    Offset localPosition = box.globalToLocal(globalPosition);

    double px = localPosition.dx;
    double py = localPosition.dy;

    if (!useSnapshot) {
      double widgetScale = box.size.width / photo.width;
      px = (px / widgetScale);
      py = (py / widgetScale);
    }

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);

    _stateController.add(Color(hex));
  }

  Future<void> loadImageBundleBytes() async {
    ByteData imageBytes = await rootBundle.load(imagePath);
    setImageBytes(imageBytes);
  }

  Future<void> loadSnapshotBytes() async {
    RenderRepaintBoundary boxPaint = paintKey.currentContext.findRenderObject();
    ui.Image capture = await boxPaint.toImage();
    ByteData imageBytes =
        await capture.toByteData(format: ui.ImageByteFormat.png);
    setImageBytes(imageBytes);
    capture.dispose();
  }

  void setImageBytes(ByteData imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }

  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  void receiveUDP() async {
    var receiver = await UDP.bind(Endpoint.loopback(port: Port(65002)));
    await receiver.listen((datagram) {
      var str = String.fromCharCodes(datagram.data);
      stdout.write(str);
      print(str);
    }, timeout: Duration(seconds: 20));
    receiver.close();
  }

  @override
  Future<void> initState() {
    receiveUDP();

    // Update UI before Start :)
    for (int index = 0; index < Hive.box('lamps').values.length; index++) {
      final lamp = Hive.box('lamps').getAt(index) as Lamp;

      if (lamp.lampOn) {
        setState(() {
          lamp.lampIconColor = kLampOnYellow;
          lamp.lampSelectColor = kWhite;
        });
      }
      if (lamp.lampSelected) {
        setState(() {
          lamp.lampSelectButtonColor = kWhite;
          lamp.lampSelectColor = kWhite;
        });
      }
      currentKey = useSnapshot ? paintKey : imageKey;
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Lightning"),
        leading: Row(
          children: [
            SizedBox(width: 5),
            IconButton(
              onPressed: () async {
                for (int i = 0; i < Hive.box("lamps").length; i++) {
                  var lamp = Hive.box('lamps').getAt(i) as Lamp;

                  connection.sendToLampOff(
                    lampIp1: lamp.lampIp1,
                    lampIp2: lamp.lampIp2,
                    lampIp3: lamp.lampIp3,
                  );

                  setState(() {
                    lamp.lampOn = false;
                    lamp.lampSelected = false;
                    lamp.lampIconColor = kGrey;
                    lamp.lampRgbColor = "0, 0, 0";
                    lamp.lampSelectColor = kGrey;
                    lamp.save();
                  });
                }
              },
              icon: Icon(Icons.flash_off_outlined),
              iconSize: 30,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.format_align_center),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FunctionScreen()),
              );
            },
          ),
          SizedBox(width: 5.0),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfigureScreen()),
              );
            },
            icon: Icon(Icons.settings),
            iconSize: 30,
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          initialData: Colors.white,
          stream: _stateController.stream,
          builder: (buildContext, snapshot) {
            pickedColor = snapshot.data ?? Colors.grey;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 158, // deviceData * 0.25
                  // ignore: deprecated_member_use
                  child: WatchBoxBuilder(
                    box: Hive.box('lamps'),
                    builder: (context, lampsBox) {
                      Rgb rgbColorCode = Rgb();
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: lampsBox.length,
                        itemBuilder: (buildContext, int index) {
                          final lamp = lampsBox.getAt(index) as Lamp;
                          if (lamp.lampOn == false) {
                            lamp.lampIconColor = kGrey;
                            lamp.save();
                          }
                          return LampSwitch(
                            index: index,
                            lampName: lamp.lampName,
                            lampOn: lamp.lampOn,
                            // Just get the Color-Value in the right Format
                            lampSelectButtonColor: lamp.lampSelected
                                ? Color.fromRGBO(
                                    rgbColorCode
                                        .getRgbSeperated(lamp.lampRgbColor)[0],
                                    rgbColorCode
                                        .getRgbSeperated(lamp.lampRgbColor)[1],
                                    rgbColorCode
                                        .getRgbSeperated(lamp.lampRgbColor)[2],
                                    1.0)
                                : Color.fromRGBO(
                                    rgbColorCode.getRgbSeperated(
                                        kLampDeactivatedColor)[0],
                                    rgbColorCode.getRgbSeperated(
                                        kLampDeactivatedColor)[1],
                                    rgbColorCode.getRgbSeperated(
                                        kLampDeactivatedColor)[2],
                                    1.0),
                            lampIconColor: Color.fromRGBO(
                                    // kLampOnIconColor
                                    rgbColorCode
                                        .getRgbSeperated(lamp.lampIconColor)[0],
                                    rgbColorCode
                                        .getRgbSeperated(lamp.lampIconColor)[1],
                                    rgbColorCode
                                        .getRgbSeperated(lamp.lampIconColor)[2],
                                    1.0) ??
                                Color.fromRGBO(
                                    rgbColorCode.getRgbSeperated(kGrey)[0],
                                    rgbColorCode.getRgbSeperated(kGrey)[1],
                                    rgbColorCode.getRgbSeperated(kGrey)[2],
                                    1.0),
                            lampSelectColor: Color.fromRGBO(
                                    // kLampOnIconColor
                                    rgbColorCode.getRgbSeperated(
                                        lamp.lampSelectColor)[0],
                                    rgbColorCode.getRgbSeperated(
                                        lamp.lampSelectColor)[1],
                                    rgbColorCode.getRgbSeperated(
                                        lamp.lampSelectColor)[2],
                                    1.0) ??
                                Color.fromRGBO(
                                    rgbColorCode.getRgbSeperated(kGrey)[0],
                                    rgbColorCode.getRgbSeperated(kGrey)[1],
                                    rgbColorCode.getRgbSeperated(kGrey)[2],
                                    1.0),
                            onSwitch: (value) {
                              // anpassen
                              setState(() {
                                lamp.lampOn = value;
                              });
                              lamp.save();

                              // Wenn Lampe an gemacht wird!
                              if (lamp.lampOn == true) {
                                setState(() {
                                  lamp.lampSelected = false;
                                  lamp.lampIconColor = kLampOnYellow;
                                  lamp.lampSelectColor = kWhite;
                                  lamp.modus = "Select";
                                });
                                lamp.save();

                                connection.sendToLampOn(
                                  lampIp1: lamp.lampIp1,
                                  lampIp2: lamp.lampIp2,
                                  lampIp3: lamp.lampIp3,
                                  lampWWValue: lampWWValue,
                                  lampWW: lamp.lampWW,
                                );
                                // Wenn Lampe aus gemacht wird!
                              } else if (lamp.lampOn == false) {
                                setState(() {
                                  lamp.lampSelected = false;
                                  lamp.lampIconColor = kGrey;
                                  lamp.lampSelectColor = kGrey;
                                  lamp.modus = "Select";
                                  lamp.save();
                                });

                                /// Udp LampOff
                                connection.sendToLampOff(
                                  lampIp1: lamp.lampIp1,
                                  lampIp2: lamp.lampIp2,
                                  lampIp3: lamp.lampIp3,
                                );
                              }
                            },
                            selectToggleStateLamp: () {
                              if (lamp.lampSelected) {
                                setState(() {
                                  lamp.lampSelected = false;
                                  lamp.lampIconColor = kLampOnYellow;
                                  lamp.lampSelectColor = lamp.lampRgbColor;
                                  lamp.save();
                                });
                              } else {
                                setState(() {
                                  lamp.lampSelected = true;
                                  lamp.lampSelectColor = kWhite;
                                  lamp.lampRgbColor = lamp.lampRgbColor;
                                  lamp.save();
                                });
                              }
                            },
                            selectLamp: () {
                              if (checkIfInCircle()) {
                                lamp.lampSelected = true;

                                if (lamp.lampOn && lamp.lampSelected) {
                                  lamp.lampRgbColor = hexToRgb(rgbColorCode);

                                  setState(() {
                                    lamp.lampSelectColor = kWhite;
                                    lamp.modus = "RGB";
                                    for (int i = 0;
                                        i < Hive.box('lamps').length;
                                        i++) {
                                      var lamp =
                                          Hive.box('lamps').getAt(i) as Lamp;
                                      if (lamp.lampSelected) {
                                        lamp.modus = "RGB";
                                      }
                                    }
                                  });
                                  setState(() {
                                    connection.sendToLampCustom(
                                      brightPerc: lamp.brightPerc,
                                      lampLength: lampsBox.length,
                                      rgbColor: lamp.lampRgbColor,
                                      lampWW: lamp.lampWW,
                                      wwValue: lampWWValue,
                                    );
                                  });

                                  /// Udp LampCustom

                                } else if (lamp.lampSelected && !lamp.lampOn) {
                                  lamp.lampSelected = false;
                                }
                              }
                              lamp.save();
                            },
                            // Select Modus ist wenn Lampe nicht selektiert ist.
                            modus: lamp.modus ??= "Select",
                            // wie hier machen mit lamp.save();
                          );
                        },
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 5.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Slider(
                                value: brightness,
                                onChanged: (value) {
                                  for (int i = 0;
                                      i < Hive.box('lamps').length;
                                      i++) {
                                    var lamp =
                                        Hive.box('lamps').getAt(i) as Lamp;

                                    if (lamp.lampSelected) {
                                      setState(() {
                                        brightness = value;
                                        brightnessPercentage = value / 100;
                                        lamp.brightPerc = brightnessPercentage;
                                        lamp.save();
                                        connection.sendToLampCustom(
                                          brightPerc: lamp.brightPerc,
                                          lampLength: Hive.box('lamps').length,
                                          rgbColor: lamp.lampRgbColor,
                                          lampWW: lamp.lampWW,
                                          wwValue: lampWWValue,
                                        );
                                      });
                                    }
                                  }
                                },
                                min: 0,
                                max: 100,
                                divisions: 100,
                                label: "Helligkeit: " +
                                    brightnessPercentage.toString(),
                                inactiveColor: Colors.grey[700],
                                activeColor: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            SizedBox(width: 5.0),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(20)),
                              child: Slider(
                                value: lampWWValue.toDouble(),
                                onChanged: (value2) {
                                  for (int i = 0;
                                      i < Hive.box('lamps').length;
                                      i++) {
                                    var lamp =
                                        Hive.box('lamps').getAt(i) as Lamp;

                                    if (lamp.lampSelected) {
                                      setState(
                                        () {
                                          if (lamp.lampWW == null ||
                                              lamp.lampWW == false ||
                                              lamp.lampWW == 0.0 ||
                                              lamp.lampWW == 0) {
                                            connection.sendToLampCustom(
                                              brightPerc: lamp.brightPerc,
                                              lampLength:
                                                  Hive.box('lamps').length,
                                              rgbColor: lamp.lampRgbColor,
                                              wwValue: lampWWValue,
                                              lampWW: lamp.lampWW,
                                            );
                                          } else {
                                            setState(() {
                                              lampWWValue = value2.toInt();
                                              if (lampWWValue != 0) {
                                                lamp.modus = "Warmweiß";
                                              } else {
                                                lamp.modus = "RGB";
                                              }
                                            });

                                            connection.sendToLampCustom(
                                              brightPerc: lamp.brightPerc,
                                              lampLength:
                                                  Hive.box('lamps').length,
                                              rgbColor: lamp.lampRgbColor,
                                              lampWW: lamp.lampWW,
                                              wwValue: lampWWValue,
                                            );
                                          }
                                          lamp.save();
                                        },
                                      );
                                    }
                                  }
                                },
                                min: 0,
                                max: 255,
                                divisions: 255,
                                activeColor: Colors.grey,
                                inactiveColor: Colors.grey[700],
                                label: "WarmWeiß-Wert",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 10.0),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  "Picked Color :",
                                  style: kCustomTextFont,
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: pickedColor,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2))
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: deviceData.height * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[800],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Stack(
                          children: <Widget>[
                            RepaintBoundary(
                              key: paintKey,
                              child: GestureDetector(
                                onPanDown: (details) {
                                  setState(() {
                                    searchPixel(details.globalPosition);
                                  });
                                },
                                onPanUpdate: (details) {
                                  searchPixel(details.globalPosition);
                                },
                                child: Center(
                                  child: Image.asset(
                                    imagePath,
                                    key: imageKey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:hive/hive.dart';
import 'package:lightcolorpicker/database/lamp.dart';
import 'package:lightcolorpicker/technology/rgb.dart';
import 'package:udp/udp.dart';

class Udp {
  // Für alle Fälle und dann entscheiden
  void sendToLampCustom({
    String rgbColor,
    double brightPerc,
    int lampLength,
    int wwValue,
    bool lampWW,
  }) async {
    Rgb rgbTech = Rgb();
    int rValue, gValue, bValue;
    for (int index = 0; index < Hive.box('lamps').values.length; index++) {
      final lamp = Hive.box('lamps').getAt(index) as Lamp;
      if (lamp.lampSelected) {
        // CustomRgb Color im Format: RgbColor(72, 255, 42, 1.0)

        // format: 0, 255, 0
        rValue = rgbTech.getRgbSeperated(rgbColor)[0];
        gValue = rgbTech.getRgbSeperated(rgbColor)[1];
        bValue = rgbTech.getRgbSeperated(rgbColor)[2];
        print("${lamp.lampName}");
        print("${rValue}:${gValue}:${bValue}");
        var lampIps = [lamp.lampIp1, lamp.lampIp2, lamp.lampIp3];
        // Rgb Value speichern in Liste
        lamp.lampRgbColor = "$rValue, $gValue, $bValue";
        lamp.save();
        print("ButtonColor" + lamp.lampSelectColor);

        //lamp.lampSelectButtonColor = "$rValue, $gValue, $bValue";
        // Richtiger UDP-Sendung zuordnen
        for (int i = 0; i < 3; i++) {
          if (lampIps[i] != null) {
            //print("lamp $i: ${lampIps[i]}");
            var multicastEndpoint = Endpoint.multicast(
                InternetAddress(lampIps[i]),
                port: Port(2390));
            var sender = await UDP.bind(Endpoint.any());

            if (lampWW != null && lampWW == true) {
              int resultR = (rValue * lamp.brightPerc).toInt();
              int resultG = (gValue * lamp.brightPerc).toInt();
              int resultB = (bValue * lamp.brightPerc).toInt();

              // modus=w&r=$resultR&g=$resultG&b=$resultB&w=$wwValue
              await sender.send(
                  "modus=w&color=$resultR:$resultG:$resultB:$wwValue".codeUnits,
                  multicastEndpoint);
            } else {
              int resultR = (rValue * lamp.brightPerc).toInt();
              int resultG = (gValue * lamp.brightPerc).toInt();
              int resultB = (bValue * lamp.brightPerc).toInt();

              await sender.send(
                  "modus=rgb&color=$resultR:$resultG:$resultB".codeUnits,
                  multicastEndpoint);
            }
          }
        }
      }
    }
  }

  // Lampe Aus
  void sendToLampOff({String lampIp1, String lampIp2, String lampIp3}) async {
    var lampIps = [lampIp1, lampIp2, lampIp3];
    for (int i = 0; i < 3; i++) {
      if (lampIps[i] != null) {
        var multicastEndpoint =
            Endpoint.multicast(InternetAddress(lampIps[i]), port: Port(2390));
        var sender = await UDP.bind(Endpoint.any());
        await sender.send("modus=rgb&color=0:0:0".codeUnits, multicastEndpoint);
      }
    }
  }

  // Lampe an
  void sendToLampOn(
      {String lampIp1,
      String lampIp2,
      String lampIp3,
      bool lampWW,
      int lampWWValue}) async {
    var lampIps = [lampIp1, lampIp2, lampIp3];

    for (int i = 0; i < 3; i++) {
      if (lampIps[i] != null) {
        var multicastEndpoint =
            Endpoint.multicast(InternetAddress(lampIps[i]), port: Port(2390));
        var sender = await UDP.bind(Endpoint.any());

        if (lampWW == true) {
          await sender.send("modus=w&color=255:192:127:$lampWWValue".codeUnits,
              multicastEndpoint);
        } else {
          await sender.send(
              "modus=rgb&color=255:192:127".codeUnits, multicastEndpoint);
        }
      }
    }
  }

  void sendFunctionToLamp(
      {String lampIp1, String lampIp2, String lampIp3, String modus}) async {
    var lampIps = [lampIp1, lampIp2, lampIp3];

    for (int i = 0; i < 3; i++) {
      if (lampIps[i] != null) {
        var multicastEndpoint =
            Endpoint.multicast(InternetAddress(lampIps[i]), port: Port(2390));
        var sender = await UDP.bind(Endpoint.any());
        switch (modus) {
          case "rainbow":
            await sender.send(
                "modus=rainbow&speed=25".codeUnits, multicastEndpoint);
            break;
          case "transition":
            break;
          case "test":
            break;
        }
      }
    }
  }
}

import 'package:hive/hive.dart';

part 'lamp.g.dart';

@HiveType(typeId: 1)
class Lamp extends HiveObject {
  @HiveField(0)
  String lampName;

  @HiveField(1)
  String lampIp1;

  @HiveField(2)
  String lampRgbColor;

  @HiveField(3)
  bool lampOn;

  @HiveField(4)
  bool isLampFirstClick;

  @HiveField(5)
  bool lampSelected;

  @HiveField(6)
  double brightPerc;

  @HiveField(7)
  String lampIconColor;

  @HiveField(8)
  String lampSelectColor;

  @HiveField(9)
  String lampSelectButtonColor;

  @HiveField(10)
  bool lampWW;

  @HiveField(11)
  String modus;

  @HiveField(12)
  String lampIp2;

  @HiveField(13)
  String lampIp3;

  Lamp({
    this.lampName,
    this.lampIp1,
    this.lampRgbColor,
    this.lampOn,
    this.isLampFirstClick,
    this.lampSelected,
    this.brightPerc,
    this.lampIconColor,
    this.lampSelectColor,
    this.lampSelectButtonColor,
    this.lampWW,
    this.modus,
    this.lampIp2,
    this.lampIp3,
  });
}

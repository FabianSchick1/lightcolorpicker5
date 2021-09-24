class Rgb {
  List<int> changeRgbString(String rgb) {
    // from  RgbColor(254, 218, 130, 1.0) to 254 218 130 Einzeln
    rgb.toString(); // 9
    String rgbCu;

    rgbCu = rgb.substring(9, rgb.length - 5);

    var k1 = rgbCu.indexOf(",", 0);
    var k2 = rgbCu.indexOf(",", k1 + 1);
    var differences = k2 - k1;

    var rValue = int.parse(rgbCu.substring(0, k1));

    var gValue = int.parse(rgbCu.substring(k1 + 1, k1 + differences).trim());

    var bValue = int.parse(
        rgbCu.substring(k1 + differences + 1, rgbCu.length - 1).trim());

    List<int> rgbValues = [rValue, gValue, bValue];
    return rgbValues;
  }

  List<int> getRgbSeperated(String rgb) {
    var k1 = rgb.indexOf(",");
    var k2 = rgb.indexOf(",", k1 + 1);
    var differences = k2 - k1;
    var rValue = int.parse(rgb.substring(0, k1));
    var gValue = int.parse(rgb.substring(k1 + 1, k1 + differences).trim());
    var bValue =
        int.parse(rgb.substring(k1 + differences + 1, rgb.length).trim());
    List<int> rgbValues = [rValue, gValue, bValue];
    return rgbValues;
  }
}

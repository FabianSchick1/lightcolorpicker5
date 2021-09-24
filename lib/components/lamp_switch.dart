import 'package:flutter/material.dart';
import 'package:lightcolorpicker/constants.dart';

class LampSwitch extends StatefulWidget {
  final Function onSwitch;
  final Function selectLamp;
  final Function selectToggleStateLamp;
  final int index;
  final String modus;

  final bool lampOn;
  final String lampName;
  final Color lampSelectColor;
  final Color lampIconColor;
  final Color lampSelectButtonColor;
  final Key key;

  LampSwitch({
    @required this.lampOn,
    @required this.lampName,
    @required this.lampSelectColor,
    @required this.lampIconColor,
    this.index,
    this.onSwitch,
    this.selectLamp,
    this.selectToggleStateLamp,
    this.key,
    this.lampSelectButtonColor,
    this.modus,
  });

  //

  @override
  _LampSwitchState createState() => _LampSwitchState();
}

class _LampSwitchState extends State<LampSwitch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[800],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${widget.lampName}",
                style: kCustomTextFont,
              ),
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: widget.lampIconColor,
                  ),
                  Switch(
                    value: widget.lampOn,
                    onChanged: widget.onSwitch,
                  ),
                ],
              ),
              Center(
                  child: Container(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: widget.lampSelectColor, width: 1.2),
                  ),
                  color: widget.lampSelectButtonColor,
                  onPressed: widget.selectLamp,
                  onLongPress: widget.selectToggleStateLamp,
                  child: Text(
                    widget.modus,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
//  w

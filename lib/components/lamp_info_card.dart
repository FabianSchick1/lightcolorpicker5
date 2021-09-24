import 'package:flutter/material.dart';

class LampInfoCard extends StatelessWidget {
  final int index;
  final String lampName;
  final String lampIp;
  final bool lampWW;

  LampInfoCard({
    @required this.index,
    @required this.lampName,
    @required this.lampIp,
    @required this.lampWW,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(lampName),
      elevation: 24.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28.0))),
      content: SizedBox(
        height: 100.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              height: 5.0,
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                SizedBox(
                  width: 80.0,
                  child: Text(
                    "IP: ",
                    style: TextStyle(fontSize: 19),
                  ),
                ),
                Text(
                  (lampIp.length >= 15)
                      ? '${lampIp.substring(0, 12)}...'
                      : lampIp,
                  style: TextStyle(fontSize: 19),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                SizedBox(
                  width: 80.0,
                  child: Text(
                    "WW:",
                    style: TextStyle(fontSize: 19),
                  ),
                ),
                Text(
                  lampWW.toString(),
                  style: TextStyle(fontSize: 19),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        OutlineButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          borderSide: BorderSide(color: Colors.grey),
          highlightedBorderColor: Colors.grey,
          child: Text(
            "Go Back",
            style: TextStyle(fontSize: 18.0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(
          width: 5.0,
        ),
      ],
    );
  }
}

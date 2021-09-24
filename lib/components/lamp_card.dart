import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'lamp_info_card.dart';

class LampCard extends StatelessWidget {
  final String lampName;
  final String lampIp;
  final int lampPort;
  final Function deleteCallback;
  final bool lampWW;
  final int index;

  final Key key;

  LampCard({
    @required this.lampName,
    this.lampIp,
    this.lampPort,
    @required this.index,
    @required this.lampWW,
    this.deleteCallback,
    this.key,
    Null Function() updateCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => LampInfoCard(
                    lampName: lampName,
                    index: index,
                    lampIp: lampIp,
                    lampWW: lampWW,
                  ),
                  barrierDismissible: false,
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      ListTile(
                        // Machen das man Lampen aktivieren und deaktivieren kann
                        leading: Icon(
                          FontAwesomeIcons.lightbulb,
                        ),
                        title: Text(
                          lampName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: deleteCallback,
                              child: Icon(
                                FontAwesomeIcons.trash,
                                size: 17.5,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.settings,
                                size: 17.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Divider(),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lightcolorpicker/components/lamp_card.dart';
import 'package:lightcolorpicker/constants.dart';
import 'package:lightcolorpicker/database/lamp.dart';
import 'package:lightcolorpicker/screens/add_lamp_group_screen.dart';

import 'add_lamps_screen.dart';

class ConfigureScreen extends StatefulWidget {
  @override
  _ConfigureScreenState createState() => _ConfigureScreenState();
}

class _ConfigureScreenState extends State<ConfigureScreen> {
  TextEditingController test = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ADD NEW LAMPS'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: _buildListView(),
            ),
            SizedBox(
              height: 20.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Colors.grey[800],
                      padding: EdgeInsets.all(20.0),
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0))),
                            backgroundColor: Colors.grey[800],
                            context: context,
                            isScrollControlled: true,
                            // Ab hier
                            builder: (context) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AddLampsScreen(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.grey)),
                      child: Row(
                        children: [
                          Center(
                            child: Text(
                              "Add new Lamp!",
                              style: kCustomTextFont.copyWith(fontSize: 20.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Colors.grey[800],
                      padding: EdgeInsets.all(20.0),
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0))),
                            backgroundColor: Colors.grey[800],
                            context: context,
                            isScrollControlled: true,
                            // Ab hier
                            builder: (context) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AddLampGroupScreen(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.grey)),
                      child: Row(
                        children: [
                          Center(
                            child: Text(
                              "Add new Lamp-Group!",
                              style: kCustomTextFont.copyWith(fontSize: 20.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    // ignore: deprecated_member_use
    return WatchBoxBuilder(
      box: Hive.box('lamps'),
      builder: (context, lampsBox) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final lamp = lampsBox.getAt(index) as Lamp;
            return LampCard(
              lampName: lamp.lampName,
              // delete
              deleteCallback: () {
                lampsBox.deleteAt(index);
              },
              lampIp: lamp.lampIp1,
              lampWW: lamp.lampWW,
              // update
              updateCallback: () {
                lampsBox.putAt(index, Lamp(lampName: lamp.lampName));
              },
              index: index,
            );
          },
          itemCount: lampsBox.values.length,
        );
      },
    );
  }
}

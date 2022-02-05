import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/position.dart';
import 'package:warehouse/Services/positionService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/View/App_Manager/positionScreen/createStorage/createStorage.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';

import 'viewStorage/viewStorage.dart';

class PositionStorageScreen extends StatefulWidget {
  const PositionStorageScreen({Key key}) : super(key: key);

  @override
  _PositionStorageScreenState createState() => _PositionStorageScreenState();
}

class _PositionStorageScreenState extends State<PositionStorageScreen> {
  loadPosition() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await PositionService().getPosition(pre.getString('token'));
  }

  bool loadtemp = false;
  void load() {
    setState(() {
      loadtemp = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateStorage()))
              .then((value) => value ? load() : null);
        },
        backgroundColor: my_org,
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: loadPosition(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return MyLoading();
            } else {
              List<Position> positions = snapshot.data;
              log(positions.toString());

              return Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Header(
                        title: 'Position Storage',
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        // color: Colors.amber,
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 150,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemCount: positions.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return Card(
                                color: positions[index].productID != null
                                    ? Colors.grey[200]
                                    : Colors.grey[50],
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          ctx,
                                          MaterialPageRoute(
                                              builder: (context) => ViewStorage(
                                                    position: positions[index],
                                                  ))).then((val) => load());
                                    },
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(positions[index].positionName),
                                          positions[index].productID != null
                                              ? Text(
                                                  positions[index].productName)
                                              : Text(
                                                  'empty',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    )),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}

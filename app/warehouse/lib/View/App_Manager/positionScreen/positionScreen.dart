import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/colors.dart';

import 'viewStorage/viewStorage.dart';

class PositionStorageScreen extends StatelessWidget {
  const PositionStorageScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addStorage();
        },
        backgroundColor: my_org,
        child: Icon(Icons.add),
      ),
      body: Container(
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
                    itemCount: 5,
                    itemBuilder: (BuildContext ctx, index) {
                      return Card(
                        color: Colors.grey[200],
                        child: InkWell(
                            onTap: () {
                              veiwStorage(ctx, index.toString());
                            },
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text('Storage #1'),
                                  Text('Empty'),
                                ],
                              ),
                            )),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

veiwStorage(ctx, a) {
  log(a);
  Navigator.push(
      ctx,
      MaterialPageRoute(
          builder: (context) => ViewStorage(
                index: a,
              )));
  return;
}

addStorage() {
  log('add');
  return;
}

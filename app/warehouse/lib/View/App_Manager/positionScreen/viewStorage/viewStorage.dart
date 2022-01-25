import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/colors.dart';

class ViewStorage extends StatefulWidget {
  const ViewStorage({Key key, this.index}) : super(key: key);

  final index;
  @override
  _ViewStorageState createState() => _ViewStorageState(index);
}

class _ViewStorageState extends State<ViewStorage> {
  final index;

  _ViewStorageState(this.index);

  bool load;

  @override
  void initState() {
    super.initState();
    load = false;
    log((load).toString());
  }

  changeLoad() {
    setState(() {
      load = !load;
      log(load.toString());
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: my_org,
        onPressed: () {
          changeLoad();
        },
        child: Icon(Icons.qr_code_scanner),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Header(
                userDrawer: false,
                title: 'Storage #${index.toString()}',
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Container(
                    width: size.width,
                    padding: EdgeInsets.all(10),
                    // color: Colors.amber,
                    child: Text(
                      'Storage ${index.toString()}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: <Widget>[
                      Center(
                        child: load
                            ? StoragedCard(size: size)
                            : EmptyCard(size: size),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 0,
                        child: IconButton(
                          iconSize: 50,
                          onPressed: () {
                            load ? removeItem() : addItem();
                          },
                          icon: Icon(
                            load ? Icons.remove_circle : Icons.add_box_sharp,
                            color: my_org,
                            // size: 50,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

addItem() {
  log('add');
}

removeItem() {
  log('remove');
}

class StoragedCard extends StatelessWidget {
  const StoragedCard({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.4,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: my_org_30,
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          'Empty',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class EmptyCard extends StatelessWidget {
  const EmptyCard({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.4,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          'Empty',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

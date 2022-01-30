import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/position.dart';
import 'package:warehouse/Services/positionService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/View/App_Manager/positionScreen/ListProductUnStored/ListProductUnStored.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/components/myDialog.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:warehouse/helper/Utils.dart';
import 'package:warehouse/helper/actionToFile.dart';

class ViewStorage extends StatefulWidget {
  const ViewStorage({Key key, this.position}) : super(key: key);

  final Position position;
  @override
  _ViewStorageState createState() => _ViewStorageState(position);
}

class _ViewStorageState extends State<ViewStorage> {
  final Position oldposition;

  _ViewStorageState(this.oldposition);

  bool loadtemp = false;
  void load() {
    setState(() {
      loadtemp = true;
    });
  }

  getdata() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    List<Position> res =
        await PositionService().getPosition(pre.getString('token'));
    return res.firstWhere((element) => element.id == oldposition.id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: getdata(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            Position position = snapshot.data;
            return Scaffold(
              drawer: MyDrawer(),
              floatingActionButton: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FloatingActionButton(
                      heroTag: 'scan',
                      backgroundColor: my_org,
                      onPressed: () {
                        load();
                        log('load');
                      },
                      child: Icon(Icons.qr_code_scanner),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 70,
                    child: FloatingActionButton(
                        heroTag: 'del',
                        onPressed: () async {
                          SharedPreferences pre =
                              await SharedPreferences.getInstance();
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Delete Storage?'),
                                    content: Text(
                                        'Delete Storage ${position.positionName} ?'),
                                    actions: [
                                      FlatButton(
                                        textColor: Color(0xFF6200EE),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      FlatButton(
                                          textColor: Color(0xFF6200EE),
                                          onPressed: () async {
                                            var res = await PositionService()
                                                .deleteStorage(
                                                    pre.getString('token'),
                                                    position.positionName);
                                            Fluttertoast.showToast(
                                                msg: res.body,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.grey
                                                    .withOpacity(0.3),
                                                textColor: Colors.black,
                                                fontSize: 16.0);
                                            if (res.statusCode == 200) {
                                              Navigator.pop(context);
                                              Navigator.pop(context, true);
                                            }
                                          },
                                          child: Text('Accept')),
                                    ],
                                  ));
                        },
                        backgroundColor: Colors.red,
                        child: Icon(Icons.remove_circle)),
                  ),
                ],
              ),
              body: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Header(
                        userDrawer: false,
                        title: 'Position',
                        preLoad: true,
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
                              'Storage ${position.positionName.toString()}',
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
                                child: position.productID != null
                                    ? StoragedCard(
                                        size: size,
                                        position: position,
                                      )
                                    : EmptyCard(size: size),
                              ),
                              Positioned(
                                left: 20,
                                bottom: 0,
                                child: IconButton(
                                  iconSize: 50,
                                  onPressed: () async {
                                    position.productID == null
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ListProductUnstored(
                                                      position: position,
                                                    ))).then(
                                            (value) => value ? load() : null)
                                        : showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Remove Item'),
                                              content: Text(
                                                  'Remove ${position.productName} out of ${position.positionName}'),
                                              actions: [
                                                FlatButton(
                                                  textColor: Color(0xFF6200EE),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                FlatButton(
                                                  textColor: Color(0xFF6200EE),
                                                  onPressed: () async {
                                                    SharedPreferences pre =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    var res =
                                                        await PositionService()
                                                            .removeItem(
                                                                pre.getString(
                                                                    'token'),
                                                                position
                                                                    .positionName);
                                                    myToast(res.body);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Accept'),
                                                ),
                                              ],
                                            ),
                                          ).then((_) => load());
                                  },
                                  icon: Icon(
                                    position.productID != null
                                        ? Icons.remove_circle
                                        : Icons.add_box_sharp,
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
          } else {
            return MyLoading();
          }
        });
  }
}

class StoragedCard extends StatelessWidget {
  const StoragedCard({
    Key key,
    @required this.size,
    this.position,
  }) : super(key: key);
  final Position position;

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.4,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Center(
              child: Image(
                image: NetworkImage(
                  getdownloadUriFromDB(position.image),
                  scale: 0.1,
                ),
              ),
            ),
          ),
          Positioned(
            child: Container(
              height: size.height,
              width: size.width,
              decoration:
                  BoxDecoration(color: Colors.grey[50].withOpacity(0.7)),
            ),
          ),
          Positioned(
            child: Center(
              child: Text(
                '${position.productName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 120,
            right: 20,
            child: Text('${position.description}'),
          ),
        ],
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

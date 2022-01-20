import 'package:flutter/material.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/colors.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({Key key}) : super(key: key);

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyDrawer(),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(flex: 1, child: Header()),
            Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: size.width,
                        child: Text(
                          'ImpExport Product!',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 24,
                              color: my_org,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      //listview
                      Container(
                          height: 1, width: size.width, color: Colors.grey),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

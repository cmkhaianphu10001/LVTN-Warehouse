import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Models/qrModel.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/Services/userService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/QRhelper.dart';
import 'package:warehouse/helper/actionToFile.dart';

class QRListScreen extends StatefulWidget {
  const QRListScreen({Key key, this.product}) : super(key: key);
  final Product product;
  @override
  _QRListScreenState createState() => _QRListScreenState(product: product);
}

class _QRListScreenState extends State<QRListScreen> {
  final Product product;

  _QRListScreenState({this.product});

  bool soldView = false;

  loadSoldView() {
    setState(() {
      soldView = !soldView;
    });
  }

  getData(String productID) async {
    SharedPreferences pre = await SharedPreferences.getInstance();

    return await ProductService()
        .getQRsByProductID(pre.getString('token'), productID);
  }

  Future<List<User>> getUsers() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await UserService().getUser(pre.getString('token'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Header(
                title: 'QRList',
                userDrawer: false,
              ),
            ),
            Expanded(
              flex: 5,
              child: FutureBuilder(
                  future: getUsers(),
                  builder: (context, snap) {
                    if (snap.data != null) {
                      List<User> users = snap.data;
                      return Container(
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Text(
                                'List QR of ${product.productName}',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: my_org,
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          log('sold view false');
                                          soldView = false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(1, 1),
                                              blurRadius: 2,
                                              color: Colors.grey,
                                            )
                                          ],
                                          color: Colors.green[100],
                                        ),
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                    Text('Stored'),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          log('sold view true');
                                          soldView = true;
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(1, 1),
                                              blurRadius: 2,
                                              color: Colors.grey,
                                            )
                                          ],
                                          color: Colors.red[50],
                                        ),
                                      ),
                                    ),
                                    Text('Sold'),
                                  ],
                                )),
                            Expanded(
                              child: FutureBuilder(
                                future: getData(product.id),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    List<QRModel> qrs = soldView
                                        ? (snapshot.data as List)
                                            .where((e) => e.cusID != null)
                                            .toList()
                                        : (snapshot.data as List)
                                            .where((e) => e.cusID == null)
                                            .toList();
                                    return ListView.builder(
                                      padding: EdgeInsets.all(20),
                                      itemCount: qrs.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(1, 1),
                                                  blurRadius: 3)
                                            ],
                                            color: qrs[index].cusID == null
                                                ? Colors.green[100]
                                                : Colors.red[50],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  height: size.width * 0.1,
                                                  width: size.width * 0.1,
                                                  // color: Colors.blueAccent,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: my_org),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Image.network(
                                                    getdownloadUriFromDB(
                                                      product.image,
                                                    ),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          'import: ${qrs[index].importDate.year} - ${qrs[index].importDate.month} - ${qrs[index].importDate.day}',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                            '\$${product.importPrice}'),
                                                        Text(
                                                            '${users.firstWhere((element) => element.id == qrs[index].managerIDImport).name}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: qrs[index].cusID != null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Column(
                                                            children: [
                                                              qrs[index].cusID !=
                                                                      null
                                                                  ? Text(
                                                                      'export: ${qrs[index].importDate.year} - ${qrs[index].importDate.month} - ${qrs[index].importDate.day}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    )
                                                                  : Text(
                                                                      '${null}'),
                                                              qrs[index].cusID !=
                                                                      null
                                                                  ? Text(
                                                                      '\$${product.importPrice * product.ratePrice}')
                                                                  : Text(
                                                                      '${null}'),
                                                              Text(
                                                                  // 'ManagerExportName'),
                                                                  '${qrs[index].cusID != null ? users.firstWhere((element) => element.id == qrs[index].managerIDExport).name : null}'),
                                                              Text(
                                                                  // 'Customer Name'),
                                                                  '${qrs[index].cusID != null ? users.firstWhere((element) => element.id == qrs[index].cusID).name : null}'),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Text(''),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  // width: size.width * 0.1,
                                                  child: IconButton(
                                                    // color: Colors.white,
                                                    onPressed: () async {
                                                      SharedPreferences pre =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            QRDialog(
                                                          token: pre.getString(
                                                              'token'),
                                                          qrID: qrs[index].id,
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.qr_code_scanner,
                                                      color: Colors.blue,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return MyLoading();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return MyLoading();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}

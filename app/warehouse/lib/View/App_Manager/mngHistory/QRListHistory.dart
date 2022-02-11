import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/historyModel.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Models/qrModel.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/helper/QRhelper.dart';
import 'package:warehouse/helper/actionToFile.dart';

import '../ProductsScreen/productDetail/productDetailScreen.dart';

class QRListHistory extends StatefulWidget {
  const QRListHistory({
    Key key,
    @required this.qrs,
    @required this.users,
    @required this.product,
  }) : super(key: key);

  final List<QRModel> qrs;
  final List<User> users;
  final Product product;

  @override
  _QRListHistoryState createState() => _QRListHistoryState(qrs, users, product);
}

class _QRListHistoryState extends State<QRListHistory> {
  final List<QRModel> qrs;
  final List<User> users;
  final Product product;
  bool soldView = false;

  _QRListHistoryState(this.qrs, this.users, this.product);

  loadSoldView() {
    setState(() {
      soldView = !soldView;
    });
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
              child: Container(
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                product: product,
                              ),
                            ));
                      },
                      child: Container(
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
                    ),
                    Expanded(
                        child: ListView.builder(
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
                            borderRadius: BorderRadius.circular(10),
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
                                    border: Border.all(color: my_org),
                                    borderRadius: BorderRadius.circular(10),
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Column(
                                      children: [
                                        Text(
                                          'import: ${qrs[index].importDate.year} - ${qrs[index].importDate.month} - ${qrs[index].importDate.day}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text('\$${product.importPrice}'),
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
                                        padding: const EdgeInsets.all(8.0),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Column(
                                            children: [
                                              qrs[index].cusID != null
                                                  ? Text(
                                                      'export: ${qrs[index].exportDate.year} - ${qrs[index].exportDate.month} - ${qrs[index].exportDate.day}',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    )
                                                  : Text('${null}'),
                                              qrs[index].cusID != null
                                                  ? Text(
                                                      '\$${qrs[index].exportPrice}')
                                                  : Text('${null}'),
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
                                          await SharedPreferences.getInstance();
                                      showDialog(
                                        context: context,
                                        builder: (context) => QRDialog(
                                          token: pre.getString('token'),
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
                    )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

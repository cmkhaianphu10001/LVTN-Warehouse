import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/position.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Models/qrModel.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/positionService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/ProductsScreen/QRList/QRListScreen.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/View/App_Manager/positionScreen/viewStorage/viewStorage.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/inkwell_link.dart';
import 'package:warehouse/helper/QRhelper.dart';
import 'package:warehouse/helper/actionToFile.dart';

class ProductDetailsWithQR extends StatefulWidget {
  const ProductDetailsWithQR({
    Key key,
    @required this.product,
    @required this.qrModel,
    @required this.users,
  }) : super(key: key);
  final Product product;
  final QRModel qrModel;
  final List<User> users;

  @override
  _ProductDetailsWithQRState createState() =>
      _ProductDetailsWithQRState(product, qrModel, users);
}

class _ProductDetailsWithQRState extends State<ProductDetailsWithQR> {
  final Product product;
  final QRModel qrModel;
  final List<User> users;
  Position position;

  _ProductDetailsWithQRState(this.product, this.qrModel, this.users);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyDrawer(),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Header(
                title: 'Product',
                userDrawer: false,
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: size.height * 5 / 6,
                      child: Stack(
                        children: <Widget>[
                          //title
                          Positioned(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              width: size.width,
                              child: Text(
                                'Product details infomation',
                                style: TextStyle(
                                    // decoration: TextDecoration.underline,
                                    fontSize: 20,
                                    color: my_org,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          //line
                          Positioned(
                            top: 25,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Container(
                                height: 1,
                                width: size.width - 40,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          //background
                          Positioned(
                            // top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Image.asset(
                              "assets/images/bgProduct.png",
                              fit: BoxFit.contain,
                            ),
                          ),
// price and input
                          Positioned(
                            right: size.width * 0.05,
                            top: size.height * 0.1,
                            child: Container(
                              width: size.width * 0.4,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "current Price: \$${product.importPrice}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Rate Price: ${product.ratePrice}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Qty: ${product.quantity}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    QRListScreen(
                                                  product: product,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.next_plan),
                                          color: my_org,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      width: size.width * 0.4,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: InkWellLink(
                                          onclick: () async {
                                            if (product.stored != null) {
                                              SharedPreferences preferences =
                                                  await SharedPreferences
                                                      .getInstance();
                                              position = await PositionService()
                                                  .getPositionbyName(
                                                      preferences
                                                          .getString('token'),
                                                      product.stored);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewStorage(
                                                      position: position,
                                                    ),
                                                  ));
                                            }
                                          },
                                          tag: 'Stored at: ' +
                                              '${product.stored == null ? null.toString() : ""}',
                                          text:
                                              '${product.stored == null ? "" : product.stored}',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
//image
                          Positioned(
                            top: size.height * 0.07,
                            left: size.width * 0.05,
                            child: Container(
                              height: size.height * 0.25,
                              width: size.height * 0.22,
                              decoration: BoxDecoration(
                                // border: Border.all(color: my_org),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: Offset(
                                        0, 7), // changes position of shadow
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Image.network(
                                getdownloadUriFromDB(
                                  product.image,
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
//Name unit supplier name
                          Positioned(
                            top: size.height * 0.35,
                            left: size.width * 0.15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${product.productName}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                Text(
                                  "${product.unit}",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "${users.firstWhere((element) => element.id == product.supID).name}",
                                  style: TextStyle(
                                    // fontStyle: FontStyle.italic,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
//decripsion
                          Positioned(
                            top: size.height * 0.55,
                            left: size.width * 0.1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: size.height * 0.25,
                              width: size.width * 0.7,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Container(
                                  width: size.width * 0.7,
                                  child: Text(
                                    "${product.description}",
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                            ),
                          ),
//QR details
                          Positioned(
                              top: size.height * 0.45,
                              left: 25,
                              right: 25,
                              child: Container(
                                width: size.width * 0.9,
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(1, 1),
                                        blurRadius: 3)
                                  ],
                                  color: qrModel.cusID == null
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                'import: ${qrModel.importDate.year} - ${qrModel.importDate.month} - ${qrModel.importDate.day}',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Text('\$${product.importPrice}'),
                                              Text(
                                                  '${users.firstWhere((element) => element.id == qrModel.managerIDImport).name}'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: qrModel.cusID != null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Column(
                                                  children: [
                                                    qrModel.cusID != null
                                                        ? Text(
                                                            'export: ${qrModel.importDate.year} - ${qrModel.importDate.month} - ${qrModel.importDate.day}',
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          )
                                                        : Text('${null}'),
                                                    qrModel.cusID != null
                                                        ? Text(
                                                            '\$${product.importPrice * product.ratePrice}')
                                                        : Text('${null}'),
                                                    Text(
                                                        // 'ManagerExportName'),
                                                        '${qrModel.cusID != null ? users.firstWhere((element) => element.id == qrModel.managerIDExport).name : null}'),
                                                    Text(
                                                        // 'Customer Name'),
                                                        '${qrModel.cusID != null ? users.firstWhere((element) => element.id == qrModel.cusID).name : null}'),
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
                                              builder: (context) => QRDialog(
                                                token: pre.getString('token'),
                                                qrID: qrModel.id,
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
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: size.height * 0.7,
                      width: size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: size.height * 0.05,
                                left: size.height * 0.05),
                            child: Text(
                              'Comment',
                              style: TextStyle(
                                color: my_org,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: size.height * 0.5,
                            child: ListView.builder(
                              padding: EdgeInsets.all(20),
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      bottom: 10, right: 5, left: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                  width: size.width,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.red,
                                          )),
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'UserName',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Something something something something something something ',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
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

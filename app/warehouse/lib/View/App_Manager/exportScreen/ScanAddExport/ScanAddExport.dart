import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/cart.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Models/qrModel.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/Services/userService.dart';
import 'package:warehouse/View/App_Manager/ProductsScreen/scanProduct/productDetailsWithQR.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/Utils.dart';
import 'package:warehouse/helper/actionToFile.dart';

class ScanAddExport extends StatefulWidget {
  const ScanAddExport({Key key}) : super(key: key);

  @override
  _ScanAddExportState createState() => _ScanAddExportState();
}

class _ScanAddExportState extends State<ScanAddExport> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  bool load = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  loadProduct(String qrID) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    if (qrID != null) {
      Product product =
          await ProductService().getProductByQRID(pre.getString('token'), qrID);

      return product;
    } else {
      return new Product(id: null, productName: "QR don't exists..");
    }
  }

  Future<List<User>> getUsers() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await UserService().getUser(pre.getString('token'));
  }

  getQR(String qrID) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await ProductService().getQRbyId(pre.getString('token'), qrID);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      floatingActionButton: Stack(children: [
        Positioned(
          right: 0,
          bottom: MediaQuery.of(context).size.height * 1 / 6,
          child: FloatingActionButton(
            heroTag: 'back',
            backgroundColor: my_org_30,
            child: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ]),
      body: FutureBuilder(
        future: getUsers(),
        builder: (context, snap) {
          if (snap.data != null) {
            List<User> users = snap.data;
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    overlay: QrScannerOverlayShape(
                      overlayColor: result != null
                          ? handleQRcode(result.code) != null
                              ? Colors.green.withOpacity(0.6)
                              : Colors.red.withOpacity(0.6)
                          : Colors.grey.withOpacity(0.6),
                      borderRadius: 30,
                      borderColor: Colors.grey,
                    ),
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: (result != null)
                        ? FutureBuilder(
                            future: loadProduct(handleQRcode(result.code)),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                if (snapshot.data.id != null) {
                                  Product product = snapshot.data;
                                  return FutureBuilder(
                                      future: getQR(handleQRcode(result.code)),
                                      builder: (context, snapsh) {
                                        if (snapsh.data != null) {
                                          QRModel qrModel = snapsh.data;
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
                                              color: qrModel.cusID == null
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: FittedBox(
                                                      fit: BoxFit.contain,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'import: ${qrModel.importDate.year} - ${qrModel.importDate.month} - ${qrModel.importDate.day}',
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                              '\$${product.importPrice}'),
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
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Column(
                                                              children: [
                                                                qrModel.cusID !=
                                                                        null
                                                                    ? Text(
                                                                        'export: ${qrModel.importDate.year} - ${qrModel.importDate.month} - ${qrModel.importDate.day}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                      )
                                                                    : Text(
                                                                        '${null}'),
                                                                qrModel.cusID !=
                                                                        null
                                                                    ? Text(
                                                                        '\$${product.importPrice * product.ratePrice}')
                                                                    : Text(
                                                                        '${null}'),
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
                                                qrModel.cusID == null
                                                    ? Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          child: cart.listQR
                                                                  .contains(
                                                                      qrModel
                                                                          .id)
                                                              ? IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (cart.listItem
                                                                            .firstWhere((element) =>
                                                                                element.pId ==
                                                                                product.id)
                                                                            .count >
                                                                        1) {
                                                                      cart.updateQuantity(
                                                                        product
                                                                            .id,
                                                                        cart.listItem.firstWhere((element) => element.pId == product.id).count -
                                                                            1,
                                                                      );
                                                                    } else {
                                                                      cart.removeItem(
                                                                          product
                                                                              .id);
                                                                    }
                                                                    cart.removeQR(
                                                                        qrModel
                                                                            .id);
                                                                    setState(
                                                                        () {
                                                                      load =
                                                                          true;
                                                                    });
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .remove_circle,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 30,
                                                                  ),
                                                                )
                                                              : IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    cart.addItem(
                                                                        product
                                                                            .id,
                                                                        1,
                                                                        product,
                                                                        double.parse((product.importPrice *
                                                                                product.ratePrice)
                                                                            .toStringAsFixed(2)));
                                                                    cart.addQR(
                                                                        qrModel
                                                                            .id);
                                                                    setState(
                                                                        () {
                                                                      load =
                                                                          true;
                                                                    });
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .add_circle,
                                                                    color:
                                                                        my_org,
                                                                    size: 30,
                                                                  ),
                                                                ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return MyLoading();
                                        }
                                      });
                                } else {
                                  return Text('${snapshot.data.productName}');
                                }
                              } else {
                                return MyLoading();
                              }
                            },
                          )
                        : Text('Scan a code'),
                  ),
                )
              ],
            );
          } else {
            return MyLoading();
          }
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

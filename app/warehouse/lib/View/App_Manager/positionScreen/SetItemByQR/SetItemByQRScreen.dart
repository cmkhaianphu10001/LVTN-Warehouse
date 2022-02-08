import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/position.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/View/App_Manager/positionScreen/productUnstoredDetails/productUnstoredDetails.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/Utils.dart';
import 'package:warehouse/helper/actionToFile.dart';

class QRViewPosition extends StatefulWidget {
  const QRViewPosition({Key key, this.position}) : super(key: key);
  final Position position;
  @override
  _QRViewPositionState createState() =>
      _QRViewPositionState(position: position);
}

class _QRViewPositionState extends State<QRViewPosition> {
  final Position position;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;

  _QRViewPositionState({this.position});

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

  @override
  Widget build(BuildContext context) {
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
      body: Column(
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
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        getdownloadUriFromDB(
                                            snapshot.data.image))),
                                Text('${snapshot.data.productName}'),
                                Text('${snapshot.data.unit}'),
                                Text('\$${snapshot.data.importPrice}'),
                                Text('qty: ${snapshot.data.quantity}'),
                                snapshot.data.stored == null
                                    ? IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductUnstoredDetails(
                                                  product: snapshot.data,
                                                  position: position,
                                                ),
                                              ));
                                        },
                                        icon: Icon(Icons.next_plan),
                                        color: my_org,
                                      )
                                    : Text('stored at ${snapshot.data.stored}'),
                              ],
                            );
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

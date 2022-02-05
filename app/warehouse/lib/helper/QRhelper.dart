import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Models/qrModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/actionToFile.dart';

class QRDialog extends StatefulWidget {
  final String qrID;
  final String token;
  const QRDialog({
    Key key,
    @required this.qrID,
    @required this.token,
  }) : super(key: key);

  @override
  _QRDialogState createState() => _QRDialogState(qrID, token);
}

class _QRDialogState extends State<QRDialog> {
  final String qrID;
  final String token;

  _QRDialogState(this.qrID, this.token);

  Future getData() async {
    QRModel qr = await ProductService().getQRbyId(token, qrID);
    Product product =
        await ProductService().getProductByID(token, qr.productID);
    log(qr.id + " : " + product.productName);
    Map<String, dynamic> res = {
      "qr": qr,
      "product": product,
    };
    return res;
  }

  final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    String qRkey = "Warehouse|";
    Size size = MediaQuery.of(context).size;
    return Screenshot(
      controller: controller,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        child: FutureBuilder(
            future: getData(),
            builder: (context, snap) {
              if (snap.data == null) {
                return MyLoading();
              } else {
                QRModel qr = snap.data["qr"];
                Product product = snap.data["product"];
                return Container(
                  padding: EdgeInsets.all(20),
                  height: size.height * 0.7,
                  width: size.width * 0.8,
                  child: Column(
                    children: [
                      buildQRcode(
                        qRkey: qRkey,
                        product: product,
                        qr: qr,
                        size: size,
                      ),
                      Container(
                        // height: size.height * 0.1,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () async {
                                final image =
                                    await controller.captureFromWidget(
                                  buildQRcode(
                                    qRkey: qRkey,
                                    product: product,
                                    qr: qr,
                                    size: size,
                                  ),
                                );
                                var res =
                                    await saveImage(imageFromScreenshot: image);
                                log(res);
                                if (res != null) {
                                  Fluttertoast.showToast(
                                      msg: 'Saved!!',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.3),
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                                }
                              },
                              icon: Icon(Icons.save_alt),
                            ),
                            IconButton(
                              onPressed: () async {
                                final image =
                                    await controller.captureFromWidget(
                                  buildQRcode(
                                    qRkey: qRkey,
                                    product: product,
                                    qr: qr,
                                    size: size,
                                  ),
                                );
                                await saveAndShare(imageFromScreenshot: image);
                              },
                              icon: Icon(Icons.share),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  Widget buildQRcode({
    Size size,
    String qRkey,
    QRModel qr,
    Product product,
  }) =>
      Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        height: size.height * 0.55,
        width: size.width * 0.8,
        child: Column(
          children: [
            QrImage(
              data: qRkey + qr.id,
              size: size.width * 0.7,
            ),
            SizedBox(
                // height: size.height * 0.05,
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: size.width * 0.3,
                  child: Text(
                    "QrID: ${qr.id}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.3,
                  child: Text(
                    "ProductID: ${product.id}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: size.width * 0.3,
                  child: Text(
                    "ImportDate: \n${qr.importDate.day} - ${qr.importDate.month} - ${qr.importDate.year}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.3,
                  child: Text(
                    "Product Name: \n${product.productName}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

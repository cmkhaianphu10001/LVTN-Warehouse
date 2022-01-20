import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/cart.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/helper/QRhelper.dart';

class ImportResult extends StatefulWidget {
  final List<dynamic> listResult;
  final Import import;
  const ImportResult({
    Key key,
    @required this.listResult,
    @required this.import,
  }) : super(key: key);

  @override
  _ImportResultState createState() => _ImportResultState(listResult, import);
}

class _ImportResultState extends State<ImportResult> {
  final List<dynamic> listResult;
  final Import import;

  _ImportResultState(this.listResult, this.import);
  List<CartItem> listItem;
  @override
  void initState() {
    listItem = import.listProduct;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Header(
                userDrawer: false,
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: size.width,
                      child: Text(
                        'Result Import!',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 24,
                            color: my_org,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //listview
                    Container(height: 1, width: size.width, color: Colors.grey),

                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: size.height * 0.7,
                      child: ListView.builder(
                          itemCount: listResult.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  alignment: Alignment.center,
                                  height: 70,
                                  width: size.width * 0.9,
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
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
                                            domain +
                                                'public/upload/images/' +
                                                listItem
                                                    .firstWhere((element) =>
                                                        element.pId ==
                                                        listResult[index]
                                                            ['productID'])
                                                    .product
                                                    .image,
                                            fit: BoxFit.contain,
                                          )),
                                      Container(
                                        width: size.width * 0.25,
                                        // color: Colors.red,
                                        child: Center(
                                          child: Text(
                                            '${listItem.firstWhere((element) => element.pId == listResult[index]['productID']).product.productName}(${listItem.firstWhere((element) => element.pId == listResult[index]['productID']).product.unit})',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: size.width * 0.2,
                                        // color: Colors.blue,
                                        child: Center(
                                          child: Text(
                                            '${import.date.year} - ${import.date.month} - ${import.date.day}',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: size.width * 0.15,
                                        // color: Colors.redAccent,
                                        child: Center(
                                          child: Text(
                                            '\$${listItem.firstWhere((element) => element.pId == listResult[index]['productID']).newPrice.toStringAsFixed(2)}',
                                          ),
                                        ),
                                      ),
                                      Container(
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
                                                qrID: listResult[index]['qrID'],
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
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

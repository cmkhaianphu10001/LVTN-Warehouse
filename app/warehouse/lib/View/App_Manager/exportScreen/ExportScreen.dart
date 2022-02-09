import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/cart.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/Services/userService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/ProductsScreen/ProductsScreen.dart';
import 'package:warehouse/View/App_Manager/ProductsScreen/productDetail/productDetailScreen.dart';
import 'package:warehouse/View/App_Manager/exportScreen/ScanAddExport/ScanAddExport.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/components/myDialog.dart';
import 'package:warehouse/components/myDropDownBtn.dart';
import 'package:warehouse/components/myPickDate.dart';
import 'package:warehouse/components/myTextView.dart';
import 'package:warehouse/components/shortButton.dart';
import 'package:warehouse/helper/Utils.dart';
import 'package:warehouse/helper/actionToFile.dart';
import 'package:warehouse/helper/validation.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({Key key}) : super(key: key);

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  Future getCustomer() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var token = pre.getString('token');
    List<User> res = await UserService().getCustomer(token);
    return res;
  }

  User customerPicked;
  String customerPickedId;
  DateTime datePicked;

  @override
  void initState() {
    datePicked = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      drawer: MyDrawer(),
      body: FutureBuilder(
        future: getCustomer(),
        builder: (context, snap) {
          if (!(snap.data != null)) {
            return MyLoading();
          } else {
            List<User> suppliers = snap.data;
            // log('${suppliers}');
            return Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Header(
                        title: 'EXPORT',
                      )),
                  Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: size.width,
                              child: Text(
                                'Export Product!',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 24,
                                    color: my_org,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            //listview
                            Container(
                                height: 1,
                                width: size.width,
                                color: Colors.grey),

                            SizedBox(
                              height: 20,
                            ),

                            MyDropDownBtn(
                              value: customerPickedId,
                              hint: 'Choose customer..',
                              label: 'Customer',
                              onChange: (String newValue) {
                                setState(() {
                                  customerPickedId = newValue;
                                  customerPicked = suppliers.firstWhere(
                                      (element) => element.id == newValue);
                                });
                              },
                              validator: (value) {
                                return Validation.checkDropDownValue(value);
                              },
                              items: suppliers.map<DropdownMenuItem<String>>(
                                  (User customer) {
                                return DropdownMenuItem<String>(
                                  value: customer.id,
                                  child: Text(customer.name),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyPickDate(
                              dateVariable:
                                  "${datePicked.day}-${datePicked.month}-${datePicked.year}",
                              onConfirm: (value) {
                                setState(() {
                                  datePicked = value;
                                });
                                print('date - $datePicked');
                              },
                              onChanged: (value) {
                                print('change $value');
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Stack(children: <Widget>[
                              Container(
                                alignment: Alignment.topCenter,
                                height: size.height * 0.3,
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: my_org),
                                  color: Colors.grey[200],
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.all(10),
                                  itemCount: cart.itemCount,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailsScreen(
                                                      product: cart
                                                          .listItem[index]
                                                          .product),
                                            ));
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(bottom: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.only(left: 5),
                                            alignment: Alignment.center,
                                            height: 70,
                                            width: size.width * 0.8,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
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
                                                        cart.listItem[index]
                                                            .product.image,
                                                      ),
                                                      fit: BoxFit.contain,
                                                    )),
                                                Container(
                                                  width: size.width * 0.25,
                                                  // color: Colors.red,
                                                  child: Center(
                                                    child: Text(
                                                      '${cart.listItem[index].product.productName}(${cart.listItem[index].product.unit})',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: size.width * 0.1,
                                                  // color: Colors.blue,
                                                  child: Center(
                                                    child: Text(
                                                      '${cart.listItem[index].count.toInt()}',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: size.width * 0.15,
                                                  // color: Colors.redAccent,
                                                  child: Center(
                                                    child: Text(
                                                      '\$${cart.listItem[index].newPrice.toStringAsFixed(2)}',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                right: -10,
                                top: -10,
                                child: IconButton(
                                  // color: Colors.white,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text('Add Item by'),
                                              content: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                height: size.height * 0.1,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons
                                                            .qr_code_scanner),
                                                        Text('Scan QR code'),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.list_alt),
                                                        Text('List Product'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actionsAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              actions: [
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ScanAddExport(),
                                                        ));
                                                  },
                                                  icon: Icon(
                                                      Icons.qr_code_scanner),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductsScreen(),
                                                        ));
                                                  },
                                                  icon: Icon(Icons.list_alt),
                                                ),
                                              ],
                                            ));
                                  },
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.blueGrey,
                                    size: 30,
                                  ),
                                ),
                              )
                            ]),
                            MyTextView(
                                content: "Total amount: \$${cart.totalAmount}"),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ShortButton(
                                  height: 40,
                                  width: size.width * 0.25,
                                  onclick: () async {
                                    if (customerPicked == null) {
                                      myToast('Please pick customer');
                                    } else {
                                      if (cart.listItem.isEmpty) {
                                        myToast('Empty Cart?...');
                                      } else {
                                        var export = new Export(
                                          date: datePicked,
                                          listProduct: cart.listItem,
                                          customer: customerPicked,
                                          totalAmount: cart.totalAmount,
                                          listQRID: cart.listQR,
                                        );
                                        SharedPreferences pre =
                                            await SharedPreferences
                                                .getInstance();
                                        var res = await ProductService()
                                            .exportProduct(
                                                pre.getString('token'), export);
                                        if (res.statusCode == 200) {
                                          myToast(res.body);
                                          cart.clear();
                                        } else {
                                          myToast(res.body);
                                        }
                                      }
                                    }
                                  },
                                  text: 'Submit',
                                ),
                                ShortButton(
                                  height: 40,
                                  width: size.width * 0.25,
                                  onclick: () {
                                    Navigator.pop(context, false);
                                  },
                                  text: 'Cancel',
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

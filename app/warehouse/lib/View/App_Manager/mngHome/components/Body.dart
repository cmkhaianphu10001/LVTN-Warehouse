import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Services/productService.dart';

import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/ProductsScreen/ProductsScreen.dart';
import 'package:warehouse/View/App_Manager/ProductsScreen/productDetail/productDetailScreen.dart';
import 'package:warehouse/View/App_Manager/Report/ReportScreen.dart';
import 'package:warehouse/View/App_Manager/exportScreen/ExportScreen.dart';
import 'package:warehouse/View/App_Manager/importScreen/ImportScreen.dart';
import 'package:warehouse/View/App_Manager/mngHistory/MngHistory.dart';
import 'package:warehouse/View/Message/ListChannel/ListChannel.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/my_icons_icons.dart';
import 'package:warehouse/colors.dart';

import 'elementbtn.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int focus = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Header(
              title: 'HOME',
            ),
          ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                height: size.height * 5 / 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //hot sale
                    Container(
                      width: size.width,
                      child: Text(
                        'Hot Sale!',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 24,
                            color: my_org,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //listview
                    Container(height: 1, width: size.width, color: Colors.grey),
                    _listHotSale(),
                    Container(height: 1, width: size.width, color: Colors.grey),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: size.width,
                      child: Text(
                        'What You Like?',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 24,
                            color: my_org,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
//row 1
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        //1.1
                        ElementButton(
                          color: my_org,
                          icon: MyIcons.input_1,
                          id: 1,
                          focus: focus,
                          label: 'Import',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImportScreen()));
                          },
                          onTapDown: (v) async {
                            setState(() {
                              focus = 1;
                            });
                          },
                          onTapUp: (v) async {
                            setState(() {
                              focus = 0;
                            });
                          },
                        ),
                        //1.2
                        ElementButton(
                          color: my_org,
                          icon: Icons.shopping_cart_outlined,
                          id: 2,
                          focus: focus,
                          label: 'Export',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExportScreen()));
                          },
                          onTapDown: (v) async {
                            setState(() {
                              focus = 2;
                            });
                          },
                          onTapUp: (v) async {
                            setState(() {
                              focus = 0;
                            });
                          },
                        ),
                        //1.3
                        ElementButton(
                          color: my_org,
                          icon: MyIcons.box,
                          id: 3,
                          focus: focus,
                          label: 'Product',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductsScreen(),
                              ),
                            );
                          },
                          onTapDown: (v) async {
                            setState(() {
                              focus = 3;
                            });
                          },
                          onTapUp: (v) async {
                            setState(() {
                              focus = 0;
                            });
                          },
                        ),
                        //1.4
                        ElementButton(
                          color: my_org,
                          icon: Icons.message,
                          id: 4,
                          focus: focus,
                          label: 'Message',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListChannel(),
                                ));
                          },
                          onTapDown: (v) async {
                            setState(() {
                              focus = 4;
                            });
                          },
                          onTapUp: (v) async {
                            setState(() {
                              focus = 0;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

//row 2
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        //2.1
                        ElementButton(
                          color: my_org,
                          icon: MyIcons.storekeeper_1,
                          id: 5,
                          focus: focus,
                          label: 'Supplier',
                          onTap: () {},
                          onTapDown: (v) async {
                            setState(() {
                              focus = 5;
                            });
                          },
                          onTapUp: (v) async {
                            setState(() {
                              focus = 0;
                            });
                          },
                        ),
                        //2.2
                        ElementButton(
                          color: my_org,
                          icon: MyIcons.housewife_shopping_1,
                          id: 6,
                          focus: focus,
                          label: 'Customer',
                          onTap: () {},
                          onTapDown: (v) async {
                            setState(() {
                              focus = 6;
                            });
                          },
                          onTapUp: (v) async {
                            setState(() {
                              focus = 0;
                            });
                          },
                        ),
                        //2.3
                        ElementButton(
                          color: my_org,
                          icon: Icons.bar_chart,
                          id: 7,
                          focus: focus,
                          label: 'Report',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportScreen(),
                                ));
                          },
                          onTapDown: (v) async {
                            setState(() {
                              focus = 7;
                            });
                          },
                          onTapUp: (v) async {
                            setState(() {
                              focus = 0;
                            });
                          },
                        ),
                        //2.4
                        ElementButton(
                          color: my_org,
                          icon: Icons.history,
                          id: 8,
                          focus: focus,
                          label: 'History',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ManagerHistoriesScreen(),
                                ));
                          },
                          onTapDown: (v) async {
                            setState(() {
                              focus = 8;
                            });
                          },
                          onTapUp: (v) async {
                            setState(() {
                              focus = 0;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(height: 1, width: size.width, color: Colors.grey),
                    Expanded(child: _listBottom())
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<Product> products =
        await ProductService().getProducts(preferences.getString('token'));
    return products;
  }

  _listHotSale() {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          List<Product> products = snapshot.data;
          products.sort((Product a, Product b) => b.sold.compareTo(a.sold));
          List<Product> hotSale = products.take(5).toList();
          return Container(
            height: 150,
            child: ListView.builder(
              itemCount: hotSale.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                vertical: 5,
              ),
              itemBuilder: (context, index) {
                return Container(
                  height: 150,
                  width: 150,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: ItemCard(
                      product: hotSale[index],
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                product: hotSale[index],
                              ),
                            ));
                      },
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return MyLoading();
        }
      },
    );
  }

  _listBottom() {
    // return FutureBuilder(
    //   builder: (context, snapshot) {
    //     if (snapshot.data != null) {
    //       return Container(
    //         height: 50,
    //         color: Colors.red,
    //       );
    //     } else {
    //       return MyLoading();
    //     }
    //   },
    // );
    return Container();
  }
}

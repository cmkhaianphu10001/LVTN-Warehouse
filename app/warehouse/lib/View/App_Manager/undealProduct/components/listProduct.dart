import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/undealProductModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/View/App_Manager/confirmUdealProduct/ConfirmUndealProductScreen.dart';

import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/actionToFile.dart';

class ListProduct extends StatefulWidget {
  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  String search;
  bool loadtemp = false;
  void load() {
    setState(() {
      loadtemp = true;
    });
  }

  var _load;
  _getRequests() async {
    setState(() {
      _load = '';
    });
  }

  String token;
  Future getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return ProductService().getUndealProducts(preferences.getString('token'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        // SizedBox(height: size.height * 0.01),
        // SearchBar(
        //   onChanged: (value) {
        //     setState(() {
        //       search = value;
        //     });
        //   },
        // ),
        FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (!(snapshot.data != null)) {
                return MyLoading();
              } else {
                return Container(
                  height: size.height * 9 / 12,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.height * 0.01,
                    ),
                    child: GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) => ItemCard(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                                new MaterialPageRoute(
                                    builder: (_) =>
                                        new ConfirmUndealProductScreen(
                                          undealProduct: snapshot.data[index],
                                        )),
                              )
                              .then((val) => val ? _getRequests() : null);
                        },
                        undealProduct: snapshot.data[index],
                      ),
                    ),
                  ),
                );
              }
            }),
      ],
    );
  }
}

class ItemCard extends StatelessWidget {
  final UndealProduct undealProduct;
  final Function onTap;

  const ItemCard({
    Key key,
    this.onTap,
    this.undealProduct,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
        // color: Colors.red,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: onTap,
            child: Stack(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(5),
                    height: size.width * 0.25,
                    width: size.width * 0.3,
                    // color: Colors.blueAccent,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: my_org),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      getdownloadUriFromDB(undealProduct.image),
                      fit: BoxFit.contain,
                    )),
                undealProduct.managerConfirm
                    ? SizedBox()
                    : Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  offset: Offset(0, 2),
                                  color: Colors.grey,
                                )
                              ]),
                        ),
                      ),
              ],
            ),
          ),
          Text(
            '${undealProduct.productName != null ? undealProduct.productName : 'ss'}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
              '\$${undealProduct.importPrice != null ? undealProduct.importPrice : ''}'),
          Text('Unit: ${undealProduct.unit != null ? undealProduct.unit : ''}'),
        ],
      ),
    );
  }
}

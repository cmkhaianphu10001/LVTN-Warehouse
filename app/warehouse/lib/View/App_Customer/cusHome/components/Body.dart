import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/Services/userService.dart';
import 'package:warehouse/View/App_Customer/Cart/CartScreen.dart';
import 'package:warehouse/View/App_Customer/cusProducts/ProductDetailsScreen/ProductDetailsScreen.dart';
import 'package:warehouse/View/App_Customer/cusProducts/ProductsScreen.dart';
import 'package:warehouse/View/App_Customer/customer_header.dart';
import 'package:warehouse/View/App_Customer/orders/OrdersScreen.dart';
import 'package:warehouse/View/Message/Channel/Channel.dart';
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
  getMyself(List<User> users) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String myID = Jwt.parseJwt(pre.getString('token'))['id'];
    User myself = users.firstWhere((User element) => element.id == myID);
    return myself;
  }

  getUser() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await UserService().getUser(pre.getString('token'));
  }

  int focus = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Header(),
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
                            Container(
                                height: 1,
                                width: size.width,
                                color: Colors.grey),
                            _listHotSale(),
                            Container(
                                height: 1,
                                width: size.width,
                                color: Colors.grey),
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
                                  icon: MyIcons.box,
                                  id: 1,
                                  focus: focus,
                                  label: 'Product',
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductsScreen(),
                                        ));
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
                                  label: 'Cart',
                                  onTap: () async {
                                    SharedPreferences pre =
                                        await SharedPreferences.getInstance();
                                    String myID = Jwt.parseJwt(
                                        pre.getString('token'))['id'];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CustomerCartScreen(myID: myID),
                                        ));
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
                                  icon: Icons.list_alt,
                                  id: 3,
                                  focus: focus,
                                  label: 'Orders',
                                  onTap: () async {
                                    User myself =
                                        await getMyself(snapshot.data);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrdersScreen(myself: myself),
                                        ));
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
                                  onTap: () async {
                                    User myself =
                                        await getMyself(snapshot.data);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Channel(
                                            myself: myself,
                                            roomID: myself.id.toString() +
                                                '_manager',
                                            target: null,
                                          ),
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
                                  icon: Icons.phone_in_talk_outlined,
                                  id: 5,
                                  focus: focus,
                                  label: 'Contact',
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
                                Container(
                                  width: size.width * 0.18,
                                ),
                                Container(
                                  width: size.width * 0.18,
                                ),
                                Container(
                                  width: size.width * 0.18,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                height: 1,
                                width: size.width,
                                color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return MyLoading();
          }
        });
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
}

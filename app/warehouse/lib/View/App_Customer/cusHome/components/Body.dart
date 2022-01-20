import 'package:flutter/material.dart';

import 'package:warehouse/helper/my_icons_icons.dart';
import 'package:warehouse/View/Profile/ProfleScreen.dart';
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
                    Container(height: 1, width: size.width, color: Colors.grey),
                    Container(
                      height: size.height * 1 / 8,
                      // color: Colors.amber,
                    ),
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
                          icon: MyIcons.box,
                          id: 1,
                          focus: focus,
                          label: 'Product',
                          onTap: () {},
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
                          onTap: () {},
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
                          icon: Icons.history,
                          id: 3,
                          focus: focus,
                          label: 'History',
                          onTap: () {},
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
                          onTap: () {},
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
                    Container(height: 1, width: size.width, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(colors: [
          my_org,
          my_org_30,
        ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Image.asset(
                'assets/images/Logo_name.png',
                scale: 2,
              )),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Color(0xffffe3c0),
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: Icon(Icons.person_outline),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:warehouse/View/App_Supplier/Header.dart';
import 'package:warehouse/colors.dart';

import 'ListProduct.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            'Products',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 24,
                                color: my_org,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        // IconButton(
                        //     onPressed: () {},
                        //     icon: Icon(
                        //       Icons.add_circle_outline_outlined,
                        //       color: my_org,
                        //     ))
                      ],
                    ),
                    Container(height: 1, width: size.width, color: Colors.grey),
                    // SizedBox(height: 10),
                    ListProduct(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

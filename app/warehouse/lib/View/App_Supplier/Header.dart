import 'package:flutter/material.dart';

import 'package:warehouse/View/Profile/ProfleScreen.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/wrapper.dart';

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
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Wrapper()),
                  (route) => false);
            },
            child: Container(
              // margin: EdgeInsets.only(bottom: 5),
              child: Image.asset(
                'assets/images/Logo_name.png',
                scale: 2,
              ),
            ),
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Color(0xffffe3c0),
              borderRadius: BorderRadius.circular(25),
            ),
            child: GestureDetector(
              child: Icon(Icons.person),
              onTap: () {
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

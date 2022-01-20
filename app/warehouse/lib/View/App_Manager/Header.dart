import 'package:flutter/material.dart';
import 'package:warehouse/View/Profile/ProfleScreen.dart';
import 'package:warehouse/colors.dart';

class Header extends StatelessWidget {
  final bool userDrawer;
  final String title;
  const Header({
    Key key,
    this.title,
    this.userDrawer = true,
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
              if (userDrawer) {
                Scaffold.of(context).openDrawer();
              } else {
                Navigator.pop(context);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                // color: my_org,
                borderRadius: BorderRadius.circular(50),
              ),
              height: 50,
              width: 50,
              child: Icon(
                userDrawer == null || userDrawer
                    ? Icons.list
                    : Icons.arrow_back,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Text(
              title != null ? title.toString() : '',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
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

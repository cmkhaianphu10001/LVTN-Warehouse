import 'package:flutter/material.dart';
import 'package:warehouse/View/Profile/ProfleScreen.dart';
import 'package:warehouse/colors.dart';

class Header extends StatelessWidget {
  final bool userDrawer;
  final String title;
  final bool preLoad;
  const Header({
    Key key,
    this.title,
    this.userDrawer = true,
    this.preLoad = false,
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
          IconButton(
            onPressed: () {
              if (userDrawer) {
                Scaffold.of(context).openDrawer();
              } else {
                preLoad ? Navigator.pop(context, true) : Navigator.pop(context);
              }
            },
            icon: Icon(
              userDrawer == null || userDrawer ? Icons.list : Icons.arrow_back,
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
            decoration: BoxDecoration(
              color: my_org_30,
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              icon: Icon(
                Icons.person_pin_circle_rounded,
                color: Colors.black,
                size: 30,
              ),
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

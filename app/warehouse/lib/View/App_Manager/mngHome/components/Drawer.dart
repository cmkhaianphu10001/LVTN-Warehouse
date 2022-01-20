import 'package:flutter/material.dart';
import 'package:warehouse/View/App_Manager/requestAccountList/ReqiuestAccountList.dart';
import 'package:warehouse/View/App_Manager/undealProduct/UndealProductScreen.dart';
import 'package:warehouse/colors.dart';
// import 'package:warehouse/screen/addProductScreen/addProductScreen.dart';
import 'package:warehouse/wrapper.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(5),
                      // color: Colors.black,
                      height: size.height * 0.2,
                      width: size.width,
                      child: Image.asset(
                        'assets/images/logo_W.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    // left: 30,
                    right: 0,
                    child: Container(
                      // color: Colors.black,
                      height: size.height * 0.03,
                      width: size.width * 0.5,
                      child: Image.asset(
                        'assets/images/NamePro.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xfffffbd2),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Wrapper()),
                  (route) => false);
            },
          ),
          Container(height: 1, width: size.width, color: Colors.grey),
          ListTile(
            leading: Icon(Icons.post_add_outlined),
            title: Text(
              'Request Add Product List',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UndealProductScreen()),
                  (route) => false);
            },
          ),
          Container(height: 1, width: size.width, color: Colors.grey),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text(
              'Request Account List',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => RequestAccountList()),
                  (route) => false);
            },
          ),
          Container(height: 1, width: size.width, color: Colors.grey),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text(
              'Request Export List',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => AddProduct()));
            },
          ),
        ],
      ),
    );
  }
}

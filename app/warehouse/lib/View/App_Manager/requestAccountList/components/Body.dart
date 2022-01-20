import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Services/authService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/UserCard.dart';
import 'package:warehouse/View/App_Manager/confirmAccountScreen/ConfirmAccountScreen.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';

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
                            'Request Account List',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 24,
                                color: my_org,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Container(height: 1, width: size.width, color: Colors.grey),
                    // SizedBox(height: 10),

                    ListRequestAccount()
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

class ListRequestAccount extends StatefulWidget {
  const ListRequestAccount({Key key}) : super(key: key);

  @override
  _ListRequestAccountState createState() => _ListRequestAccountState();
}

class _ListRequestAccountState extends State<ListRequestAccount> {
  Future getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var result =
        await AuthService().getUncheckUSer(preferences.getString('token'));
    return result;
  }

  var load = '';
  loading() {
    setState(() {
      load = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getData(),
        builder: (context, snap) {
          if (!(snap.data != null)) {
            return MyLoading();
          } else {
            return Container(
              height: size.height * 9 / 12,
              // color: Colors.red,
              // padding: EdgeInsets.only(top: 20),
              child: ListView.builder(
                itemCount: snap.data.length,
                itemBuilder: (context, index) => UserCard(
                  index: index,
                  user: snap.data[index],
                  onTap: () {
                    Navigator.of(context)
                        .push(
                          new MaterialPageRoute(
                              builder: (_) => new ConfirmAccountScreen(
                                    user: snap.data[index],
                                  )),
                        )
                        .then((val) => val ? loading() : null);
                  },
                ),
              ),
            );
          }
        });
  }
}

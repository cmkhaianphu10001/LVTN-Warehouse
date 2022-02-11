import 'package:flutter/material.dart';
import 'package:warehouse/Models/historyModel.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/mngHistory/QRListHistory.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/helper/actionToFile.dart';

class DetailsHistory extends StatelessWidget {
  const DetailsHistory({
    Key key,
    @required this.history,
    @required this.userTarget,
    @required this.manager,
    @required this.users,
  }) : super(key: key);
  final HistoryModel history;

  final List<User> users;
  final User userTarget;
  final User manager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Header(
              title: 'Details History',
              userDrawer: false,
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    'History Details',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 24,
                        color: my_org,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${history.typeHistory}',
                        style: TextStyle(
                          color: my_org,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: history.listProduct.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => QRListHistory(
                                        qrs: history.listProduct[index].qrs,
                                        users: users,
                                        product:
                                            history.listProduct[index].product,
                                      ))));
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 15,
                                offset: Offset(3, 3),
                              ),
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 15,
                                offset: Offset(-4, -4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Image(
                                      image: NetworkImage(
                                        getdownloadUriFromDB(history
                                            .listProduct[index].product.image),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${history.listProduct[index].product.productName}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${history.listProduct[index].product.unit}',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        'Stored: ${history.listProduct[index].product.quantity}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'x${history.listProduct[index].count}',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '\$${history.listProduct[index].product.importPrice}',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white),
                  alignment: Alignment.centerLeft,
                  child: Text('total Amount \n\$${history.totalAmount}'),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order ID'),
                            Text('Order Date'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${history.id}'),
                            Text(
                                '${history.date.day} - ${history.date.month} - ${history.date.year} '),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            getdownloadUriFromDB(userTarget.image),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${userTarget.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '${userTarget.email}',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            getdownloadUriFromDB(manager.image),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${manager.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '${manager.email}',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

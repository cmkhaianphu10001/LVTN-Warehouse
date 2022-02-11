import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/historyModel.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/Services/userService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/mngHistory/DetailsHistory.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/actionToFile.dart';

class ManagerHistoriesScreen extends StatefulWidget {
  const ManagerHistoriesScreen({Key key}) : super(key: key);

  @override
  _ManagerHistoriesScreenState createState() => _ManagerHistoriesScreenState();
}

class _ManagerHistoriesScreenState extends State<ManagerHistoriesScreen> {
  DateTime selectedDate;
  List<HistoryModel> histories;
  List<User> users;
  Future<List<HistoryModel>> getHistories() async {
    return await ProductService().getHistory();
  }

  Future<List<User>> getUser() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await UserService().getUser(pre.getString('token'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Header(
                title: 'History',
                userDrawer: false,
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (selectedDate != null) {
                        setState(() {
                          selectedDate = null;
                        });
                      } else {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime(2018, 1, 5),
                          maxTime: DateTime(2022, 12, 20),
                          onChanged: (value) {},
                          onConfirm: (value) {
                            setState(() {
                              selectedDate = value;
                            });
                          },
                          currentTime: DateTime.now(),
                          locale: LocaleType.vi,
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: selectedDate != null
                            ? [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.grey,
                                  offset: Offset(4, 4),
                                ),
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.white,
                                  offset: Offset(-4, -4),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        selectedDate != null
                            ? '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}'
                            : '__-__-____',
                        style: TextStyle(
                          color: my_org,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: Future.wait([getHistories(), getUser()]),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          histories = selectedDate != null
                              ? (snapshot.data[0] as List)
                                  .where((element) =>
                                      element.date.day == selectedDate.day &&
                                      element.date.month ==
                                          selectedDate.month &&
                                      element.date.year == selectedDate.year)
                                  .toList()
                              : snapshot.data[0];
                          users = snapshot.data[1];
                          return ListView.builder(
                            itemCount: histories.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsHistory(
                                        history: histories[index],
                                        userTarget: users.firstWhere(
                                            (User element) =>
                                                element.id ==
                                                histories[index].userTargetID),
                                        manager: users.firstWhere(
                                            (User element) =>
                                                element.id ==
                                                histories[index].managerID),
                                        users: users,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey[200],
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${histories[index].typeHistory}',
                                        style: TextStyle(
                                          color: my_org,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                height: 70,
                                                width: 70,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Image(
                                                    image: NetworkImage(
                                                      getdownloadUriFromDB(
                                                          histories[index]
                                                              .listProduct[0]
                                                              .product
                                                              .image),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                          Expanded(
                                            flex: 8,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    '${histories[index].listProduct[0].product.productName}',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${histories[index].listProduct[0].product.unit}',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'x${histories[index].listProduct[0].count}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  '\$${histories[index].listProduct[0].product.importPrice.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        height: 1,
                                        width: size.width,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                                '${histories[index].listProduct.length} ${histories[index].listProduct.length != 1 ? "items" : "item"}'),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                  'Date: ${histories[index].date.day}-${histories[index].date.month}-${histories[index].date.year}'),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                  'TotalAmount \$${histories[index].totalAmount.toStringAsFixed(2)}'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return MyLoading();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

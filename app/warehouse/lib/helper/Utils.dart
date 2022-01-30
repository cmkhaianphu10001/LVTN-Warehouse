import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Util {
  // static List<CustomerPurcharByMonth> remakeListCustomerPurcharByMonth(
  //     List<CustomerPurcharByMonth> list) {
  //   Map<String, double> res = {};
  //   list.forEach((element) {
  //     if (res.containsKey(element.cusId)) {
  //       res[element.cusId] += element.amonth;
  //     } else {
  //       res[element.cusId] = element.amonth;
  //     }
  //   });
  //   List<CustomerPurcharByMonth> result = [];
  //   res.forEach((key, value) {
  //     result.add(
  //       CustomerPurcharByMonth(
  //         amonth: value,
  //         cusId: key,
  //         cusName: list.firstWhere((element) => element.cusId == key).cusName,
  //       ),
  //     );
  //   });
  //   return result;
  // }

  // static List<AmonthByMonth> remakeListAmonthByMonth(List<AmonthByMonth> list) {
  //   Map<String, double> res = {};
  //   list.forEach((element) {
  //     if (res.containsKey(element.date.toString())) {
  //       res[element.date.toString()] += element.totalAmonth;
  //     } else {
  //       res[element.date.toString()] = element.totalAmonth;
  //     }
  //   });
  //   List<AmonthByMonth> result = [];
  //   res.forEach((key, value) {
  //     result.add(
  //       AmonthByMonth(
  //         date: int.parse(key),
  //         totalAmonth: value,
  //       ),
  //     );
  //   });
  //   return result;
  // }

  // static List<double> toList30Day(List<AmonthByMonth> list) {
  //   List<double> res = [];
  //   for (int x = 0; x <= 30; x++) {
  //     if (x == 0 && list.length == 0) {
  //       res.add(1);
  //     } else {
  //       res.add(0);
  //     }
  //   }
  //   list.forEach((element) {
  //     res[element.date] = element.totalAmonth;
  //   });
  //   return res;
  // }

  // static double sumOfList(List<double> list) {
  //   double res = 0.0;
  //   list.forEach((element) {
  //     res = res + element;
  //   });
  //   log('$res');
  //   return res;
  // }

  // sortData(List<dynamic> list, String tag) {
  //   return list.sort((a, b) => a.positionName
  //       .toString()
  //       .toLowerCase()
  //       .compareTo(b.positionName.toString().toLowerCase()));
  // }
}

myToast(toastText) {
  Fluttertoast.showToast(
      msg: toastText,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.withOpacity(0.3),
      textColor: Colors.black,
      fontSize: 16.0);
}

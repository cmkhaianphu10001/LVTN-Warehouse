import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:warehouse/Models/userModel.dart';

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

handleQRcode(String resultCode) {
  List<String> results = resultCode.split('|').toList();
  if (results[0] != 'Warehouse') {
    return null;
  } else {
    return results[1];
  }
}

getRoomId(User a, User b) {
  if (a.role != 'manager') return '${a.id}_manager';
  if (b.role != 'manager') return '${b.id}_manager';
}

getProcess(int process) {
  switch (process) {
    case 0:
      return 'Denie';
      break;
    case 1:
      return 'Checking';
      break;
    case 2:
      return 'Accept';
      break;
    case 3:
      return 'Exported';
      break;
    case 4:
      return 'Completed';
      break;
    default:
  }
}

bool compare2Json(Map<String, dynamic> json1, Map<String, dynamic> json2) {
  if (json1.length != json2.length) {
    return false;
  }
  json1.forEach((key1, value1) {
    json2.forEach((key2, value2) {
      if (key1 == key2) {
        if (value1 != value2) {
          return false;
        }
      }
    });
  });
  return true;
}

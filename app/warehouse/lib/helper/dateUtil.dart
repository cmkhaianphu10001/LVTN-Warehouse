import 'dart:developer';

class DateUtil {
  static String datetime2String(DateTime date) {
    // Date 2020-12-14 => String 20201214
    var year = date.year.toString();
    var m = date.month.toString();
    if (date.month < 10) {
      m = '0' + date.month.toString();
    }
    var d = date.day.toString();
    if (date.day < 10) {
      d = '0' + date.day.toString();
    }
    return (year + m + d);
  }

  static String string2StringFormated(String value) {
    // log('$value');
    // String 20201214 => String 2020-12-14
    if (value.length != 8) {
      log('Util string2StringFormated failed');
      return null;
    } else {
      var val = int.parse(value);
      String yy = (val ~/ 10000).toString();
      String mm;
      if (((val % 10000) ~/ 100) < 10) {
        mm = '0' + ((val % 10000) ~/ 100).toString();
      } else {
        mm = ((val % 10000) ~/ 100).toString();
      }
      String dd;
      if (((val % 10000) % 100) < 10) {
        dd = '0' + ((val % 10000) % 100).toString();
      } else {
        dd = ((val % 10000) % 100).toString();
      }
      // log('$val');
      String res = yy + '-' + mm + '-' + dd;
      return res;
    }
  }

  static DateTime string2Date(String value) {
    // String 20201214 => Date 2020-12-14

    DateTime res;

    var x = string2StringFormated(value);
    // log('$x');
    res = DateTime.parse(x);
    // log('$res');
    return res;
  }

  static bool checkSameMonth({String month, String value}) {
    // log('$month');
    // 20200315 20200317
    var x = string2Date(month).month;
    // log('x$x');
    var y = string2Date(value).month;
    // log('y$y');
    if (x == y) {
      return true;
    }
    return false;
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/cart.dart';
import 'package:warehouse/Models/historyModel.dart';
import 'dart:io';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Models/qrModel.dart';
import 'package:warehouse/Models/undealProductModel.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/helper/uploadImage.dart';

class ProductService {
  var url = domain + 'api/product/';

  //add new request
  addNewProduct(Product newProduct, File imagePicked, String token) async {
    // print(newProduct.toJson());
    // print(imagePicked);

    // newProductf.image = '';
    try {
      String uri = await Storage().uploadImage(imagePicked, '/product_images/');
      newProduct.image = uri;
      var newProductf = jsonEncode(newProduct.toJson());
      var res = await http.post(
        Uri.parse(url + 'addNewProduct'),
        body: newProductf,
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
      );
      // print(res.statusCode.toString());
      return res;
    } catch (e) {
      print(e);
    }
  }

  //get undeal product
  getUndealProducts(String token) async {
    // print(token);
    // var bodyf = jsonEncode(newUser.toJson());
    try {
      var res = await http.get(
        Uri.parse(url + 'getUndealProducts'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
      );
      List<UndealProduct> undealProducts = (jsonDecode(res.body) as List)
          .map((e) => UndealProduct.fromJson(e))
          .toList();
      print("undeal Product count: ${undealProducts.length}");
      return undealProducts;
    } catch (e) {
      print('err : ' + e.toString());
    }
  }

//get undeal product
  getUndealProductsBySupID(String token, String supId) async {
    // print(token);
    // var bodyf = jsonEncode(newUser.toJson());
    try {
      var res = await http.get(
        Uri.parse(url + 'getUndealProducts'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
          "supid": supId,
        },
      );
      List<UndealProduct> undealProducts = (jsonDecode(res.body) as List)
          .map((e) => UndealProduct.fromJson(e))
          .toList();
      print("undeal Product count: ${undealProducts.length}");
      return undealProducts;
    } catch (e) {
      log('err : ' + e.toString());
    }
  }

//get all product
  getProducts(String token) async {
    // print(token);
    // var bodyf = jsonEncode(newUser.toJson());
    try {
      var res = await http.get(
        Uri.parse(url + 'getProducts'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
      );
      List<Product> product = (jsonDecode(res.body) as List)
          .map((e) => Product.fromJson(e))
          .toList();
      print(product.length);
      product.sort((a, b) =>
          a.productName.toLowerCase().compareTo(b.productName.toLowerCase()));
      return product;
    } catch (e) {
      print('err : ' + e.toString());
    }
  }

//get product supplier
  getProductBySupplierID(String token, String supId) async {
    try {
      var res = await http.get(
        Uri.parse(url + 'getProducts'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
          "supid": supId,
        },
      );
      List<Product> product = (jsonDecode(res.body) as List)
          .map((e) => Product.fromJson(e))
          .toList();
      print('product count : ' + product.length.toString());
      return product;
    } catch (e) {
      log(e);
    }
  }

  getProductByID(String token, String productID) async {
    try {
      var res = await http.get(
        Uri.parse(url + 'getProducts'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
          "productID": productID,
        },
      );
      Product product = Product.fromJson(jsonDecode(res.body));
      print('product name : ' + product.productName.toString());
      return product;
    } catch (e) {
      log(e);
    }
  }

  getProductByQRID(String token, String qrID) async {
    try {
      var res = await http.get(
        Uri.parse(url + 'getProducts'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
          "qrid": qrID,
        },
      );
      if (res.statusCode == 400) {
        return new Product(id: null, productName: res.body);
      }

      Product product = Product.fromJson(jsonDecode(res.body));
      print('product name : ' + product.productName.toString());
      return product;
    } catch (e) {
      log(e);
    }
  }

  confirmUndealProduct(String token, String undealProductID, bool action,
      {double newPrice, ratePrice}) async {
    try {
      var res = await http.post(
        Uri.parse(url + 'confirmUndealProduct'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
        body: jsonEncode({
          'undealProductID': undealProductID,
          'newPrice': newPrice,
          'ratePrice': ratePrice,
          'action': action,
        }),
      );
      return res;
    } catch (e) {
      print(e);
    }
  }

  importProduct(String token, Import import) async {
    var list = [];
    import.listProduct.forEach((e) {
      list.add({
        "productID": e.product.id,
        "quantity": e.count,
        "newPrice": e.newPrice
      });
    });
    try {
      var res = await http.post(
        Uri.parse(url + 'importProducts'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
        body: jsonEncode({
          'supID': import.supplier.id,
          'importDate':
              "${import.date.year}/${import.date.month}/${import.date.day} 10:10:10 +0000",
          'totalAmount': import.totalAmount,
          'listItem': list,
        }),
      );

      return res;
    } catch (e) {
      print(e);
    }
  }

  exportProduct(String token, Export export) async {
    var listItem = [];
    var listQR = [];
    export.listProduct.forEach((e) {
      listItem.add({
        "productID": e.product.id,
        "quantity": e.count,
        "newPrice": e.newPrice
      });
    });
    export.listQRID.forEach((element) {
      listQR.add({'qrID': element});
    });
    try {
      var res = await http.post(
        Uri.parse(url + 'exportProducts'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
        body: jsonEncode({
          'cusID': export.customer.id,
          'exportDate':
              "${export.date.year}/${export.date.month}/${export.date.day} 10:10:10 +0000",
          'totalAmount': export.totalAmount,
          'listItem': listItem,
          'listQR': listQR,
        }),
      );

      return res;
    } catch (e) {
      print(e);
    }
  }

  getQRbyId(String token, String qrID) async {
    try {
      var res = await http.get(
        Uri.parse(url + 'getQRByID'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
          "qrID": qrID,
        },
      );
      // log(DateTime.parse(jsonDecode(res.body)['importDate']).year.toString());
      QRModel result = QRModel.fromJson(jsonDecode(res.body));

      return result;
    } catch (e) {
      log(e);
    }
  }

  getQRsByProductID(String token, String productID) async {
    try {
      var res = await http.get(
        Uri.parse(url + 'getQRs'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
          "productid": productID,
        },
      );
      List<QRModel> qRs = (jsonDecode(res.body) as List)
          .map((e) => QRModel.fromJson(e))
          .toList();

      qRs.sort((a, b) => a.importDate.compareTo(b.importDate));
      qRs = List.from(qRs.reversed);
      return qRs;
    } catch (e) {
      log(e);
    }
  }

  getQRs(String token) async {
    try {
      var res = await http.get(
        Uri.parse(url + 'getQRs'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
      );
      List<QRModel> qRs = (jsonDecode(res.body) as List)
          .map((e) => QRModel.fromJson(e))
          .toList();

      qRs.sort((a, b) => a.importDate.compareTo(b.importDate));
      qRs = List.from(qRs.reversed);
      return qRs;
    } catch (e) {
      log(e);
    }
  }

  getHistory({String userTargetID}) async {
    SharedPreferences pre = await SharedPreferences.getInstance();

    try {
      var res = await http.get(
        Uri.parse(url + 'getHistories'),
        headers: userTargetID != null
            ? {
                "content-type": "application/json",
                "authorization": pre.getString('token'),
                "usertargetid": userTargetID,
              }
            : {
                "content-type": "application/json",
                "authorization": pre.getString('token'),
              },
      );

      List<HistoryModel> histories = (jsonDecode(res.body) as List)
          .map((e) => HistoryModel.fromJson(e))
          .toList();
      histories.sort(
        (a, b) => b.date.compareTo(a.date),
      );

      List<ItemOfHistory> itemsOfHistory = await getItemOfHistory();
      List<Product> products = await getProducts(pre.getString('token'));
      List<QRModel> qrs = await getQRs(pre.getString('token'));

      histories.forEach((HistoryModel history) {
        history.listProduct = itemsOfHistory
            .where((ItemOfHistory item) => item.parentID == history.id)
            .toList();
        history.listProduct.forEach((ItemOfHistory e) {
          e.product =
              products.firstWhere((product) => product.id == e.productID);
        });
        if (history.typeHistory == 'import') {
          history.listProduct.forEach((ItemOfHistory e) {
            e.qrs = qrs
                .where((QRModel element) =>
                    (element.importIDhistory == history.id &&
                        element.productID == e.productID))
                .toList();
          });
        } else if (history.typeHistory == 'export') {
          history.listProduct.forEach((ItemOfHistory e) {
            e.qrs = qrs
                .where((QRModel element) =>
                    (element.exportIDhistory == history.id &&
                        element.productID == e.productID))
                .toList();
          });
        }
      });
      return histories;
    } catch (e) {
      log(e);
    }
  }

  getItemOfHistory({String parentID}) async {
    SharedPreferences pre = await SharedPreferences.getInstance();

    try {
      var res = await http.get(
        Uri.parse(url + 'getItemOfHistory'),
        headers: {
          "content-type": "application/json",
          "authorization": pre.getString('token'),
          "parentid": parentID,
        },
      );
      List<ItemOfHistory> items = (jsonDecode(res.body) as List)
          .map((e) => ItemOfHistory.fromJson(e))
          .toList();
      return items;
    } catch (e) {
      log(e);
    }
  }
}

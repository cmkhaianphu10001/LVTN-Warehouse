import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:warehouse/Models/cart.dart';
import 'dart:io';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Models/qrModel.dart';
import 'package:warehouse/Models/undealProductModel.dart';
import 'package:warehouse/colors.dart';

class ProductService {
  var url = domain + 'api/product/';

  //add new request
  addNewProduct(Product newProduct, File imagePicked, String token) async {
    // print(newProduct.toJson());
    // print(imagePicked);
    var newProductf = jsonEncode(newProduct.toJson());
    // newProductf.image = '';
    try {
      var res1 = await http.post(
        Uri.parse(url + 'addNewProduct'),
        body: newProductf,
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
      );
      // print(res1.statusCode.toString() + ":" + jsonDecode(res1.body)['_id']);

      http.MultipartRequest request =
          new http.MultipartRequest("POST", Uri.parse(url + 'includeImage'));
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('image', imagePicked.path);
      request.files.add(multipartFile);
      request.headers.addAll({
        "content-type": "multipart/form-data",
        "authorization": token,
        "productid": jsonDecode(res1.body)['_id'],
      });

      var res = await request.send();

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
              "${import.date.year}-${import.date.month}-${import.date.day}",
          'totalAmount': import.totalAmount,
          'listItem': list,
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
}

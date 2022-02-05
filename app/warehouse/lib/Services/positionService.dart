import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:warehouse/Models/position.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/colors.dart';

class PositionService {
  var url = domain + 'api/positionstorage/';

  getPosition(String token) async {
    try {
      var res = await http.get(
        Uri.parse(url + 'getposition'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
        },
      );
      List<Position> positions = (jsonDecode(res.body) as List)
          .map((e) => Position.fromJson(e))
          .toList();
      // log(positions.toString());
      positions.sort((a, b) =>
          a.positionName.toLowerCase().compareTo(b.positionName.toLowerCase()));
      return positions;
    } catch (e) {
      log(e.toString());
    }
  }

  getPositionbyName(String token, String positionName) async {
    try {
      var res = await http.get(
        Uri.parse(url + 'getposition'),
        headers: {
          "content-type": "application/json",
          "authorization": token,
          "positionname": positionName,
        },
      );
      Position positions = Position.fromJson(jsonDecode(res.body));

      return positions;
    } catch (e) {
      log(e.toString());
    }
  }

  createStorage(String token, String positionName, String description) async {
    try {
      var res = await http.post(Uri.parse(url + 'createPosition'),
          headers: {
            "content-type": "application/json",
            "authorization": token,
          },
          body: jsonEncode({
            "description": description,
            "positionName": positionName,
          }));
      // log(res.statusCode.toString());
      return res;
    } catch (e) {
      log(e.toString());
    }
  }

  deleteStorage(String token, String positionName) async {
    try {
      var res = await http.post(Uri.parse(url + 'deletePosition'),
          headers: {
            "content-type": "application/json",
            "authorization": token,
          },
          body: jsonEncode({
            "positionName": positionName,
          }));
      // log(res.statusCode.toString());
      return res;
    } catch (e) {
      log(e.toString());
    }
  }

  getUnstoredItem(String token) async {
    List<Product> products = (await ProductService().getProducts(token) as List)
        .where((element) => element.stored == null)
        .toList();
    return products;
  }

  setItem(String token, String productID, String positionName) async {
    try {
      var res = await http.post(Uri.parse(url + 'setItem'),
          headers: {
            "content-type": "application/json",
            "authorization": token,
          },
          body: jsonEncode({
            "positionName": positionName,
            "productID": productID,
          }));
      // log(res.statusCode.toString());
      return res;
    } catch (e) {
      log(e.toString());
    }
  }

  removeItem(String token, String positionName) async {
    try {
      var res = await http.post(Uri.parse(url + 'removeItem'),
          headers: {
            "content-type": "application/json",
            "authorization": token,
          },
          body: jsonEncode({
            "positionName": positionName,
          }));
      // log(res.statusCode.toString());
      return res;
    } catch (e) {
      log(e.toString());
    }
  }
}

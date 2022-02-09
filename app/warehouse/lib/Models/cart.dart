import 'package:flutter/material.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Models/qrModel.dart';
import 'package:warehouse/Models/userModel.dart';

class CartItem {
  final String pId;
  final Product product;
  final int count;
  final double newPrice;

  CartItem(
      {@required this.pId,
      @required this.product,
      @required this.count,
      @required this.newPrice});
}

class Cart extends ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  Map<String, String> _qrList = {};

  Map<String, String> get qrList {
    return {..._qrList};
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(String pId, int quantity, Product product, double price) {
    if (_items.containsKey(pId)) {
      // log('update' + product.productName);
      _items.update(
          pId,
          (existingCartItem) => CartItem(
              pId: pId,
              product: existingCartItem.product,
              count: existingCartItem.count + quantity,
              newPrice: existingCartItem.newPrice));
    } else {
      // log('add' + product.productName);
      _items.putIfAbsent(
          pId,
          () => CartItem(
                product: product,
                pId: pId,
                count: quantity,
                newPrice: price,
              ));
    }
    notifyListeners();
  }

  void addQR(String qrID) {
    if (!_qrList.containsKey(qrID)) {
      _qrList.putIfAbsent(qrID, () => qrID);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeQR(String id) {
    _qrList.remove(id);
    notifyListeners();
  }

  void updateQuantity(String id, int qty) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].count > 1) {
      _items.update(
          id,
          (existingCartItem) => CartItem(
              pId: existingCartItem.pId,
              product: existingCartItem.product,
              count: qty,
              newPrice: existingCartItem.newPrice));
    }
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.newPrice * cartItem.count;
    });
    return total;
  }

  List<CartItem> get listItem {
    List<CartItem> list = [];
    _items.forEach((key, value) {
      list.add(value);
    });
    return list;
  }

  List<String> get listQR {
    List<String> list = [];
    _qrList.forEach((key, value) {
      list.add(value);
    });
    return list;
  }

  void clear() {
    _items = {};
    _qrList = {};
    notifyListeners();
  }
}

class Import {
  Import({
    this.supplier,
    this.date,
    this.totalAmount,
    this.listProduct,
  });
  final User supplier;
  final DateTime date;
  final double totalAmount;
  final List<CartItem> listProduct;
}

class Export {
  Export({
    this.customer,
    this.date,
    this.totalAmount,
    this.listProduct,
    this.listQRID,
  });
  final User customer;
  final DateTime date;
  final double totalAmount;
  final List<CartItem> listProduct;
  final List<String> listQRID;
}

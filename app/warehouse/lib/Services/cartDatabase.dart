import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/helper/Utils.dart';

class CartDatabase {
  var cart = 'cart';
  var cartItems = 'cartitems';
  var firebaseFirestore = FirebaseFirestore.instance;
  addItem({
    @required String myID,
    @required Product product,
    @required int count,
  }) {
    firebaseFirestore
        .collection(cart)
        .doc(myID)
        .collection(cartItems)
        .doc(product.id)
        .get()
        .then((value) => {
              if (value.data() != null)
                {
                  if (value.get('count') + int.parse(count.toString()) <=
                      product.quantity)
                    {
                      firebaseFirestore
                          .collection(cart)
                          .doc(myID)
                          .collection(cartItems)
                          .doc(product.id)
                          .update({
                        'count':
                            value.get('count') + int.parse(count.toString()),
                      }),
                      myToast('Done')
                    }
                  else
                    {myToast('Over quantity in Cart')}
                }
              else
                {
                  firebaseFirestore
                      .collection(cart)
                      .doc(myID)
                      .collection(cartItems)
                      .doc(product.id)
                      .set({
                    'productID': product.id,
                    'count': int.parse(count.toString()),
                    'price': double.parse(
                        (product.ratePrice * product.importPrice)
                            .toStringAsFixed(2))
                  }),
                  myToast('Done')
                },
              updateQuantity(myID: myID),
            });
  }

  updateQuantity({
    @required String myID,
  }) async {
    double totalAmount = 0;
    QuerySnapshot snapshot = await firebaseFirestore
        .collection(cart)
        .doc(myID)
        .collection(cartItems)
        .get();
    List<dynamic> listSnapshotItemCart = snapshot.docs;

    listSnapshotItemCart.forEach((element) {
      totalAmount += double.parse(
          (element.data()['price'] * element.data()['count'] as double)
              .toStringAsFixed(2));
    });
    firebaseFirestore.collection(cart).doc(myID).set({
      'totalAmount': double.parse(totalAmount.toStringAsFixed(2)),
    });
  }

  removeItem({
    @required String myID,
    @required Product product,
  }) {
    firebaseFirestore
        .collection(cart)
        .doc(myID)
        .collection(cartItems)
        .doc(product.id)
        .delete();
    updateQuantity(myID: myID);
  }

  plus1QtyItem({
    @required String myID,
    @required Product product,
  }) {
    firebaseFirestore
        .collection(cart)
        .doc(myID)
        .collection(cartItems)
        .doc(product.id)
        .get()
        .then((value) => {
              if (value.get('count') >= product.quantity)
                {
                  myToast('Over quantity in Cart'),
                }
              else
                {
                  firebaseFirestore
                    ..collection(cart)
                        .doc(myID)
                        .collection(cartItems)
                        .doc(product.id)
                        .update({
                      'count': value.get('count') + 1,
                    }),
                }
            });
    updateQuantity(myID: myID);
  }

  subtract1QtyItem({
    @required String myID,
    @required Product product,
  }) {
    firebaseFirestore
        .collection(cart)
        .doc(myID)
        .collection(cartItems)
        .doc(product.id)
        .get()
        .then((value) => {
              if (value.get('count') <= 1)
                {
                  removeItem(myID: myID, product: product),
                }
              else
                {
                  firebaseFirestore
                    ..collection(cart)
                        .doc(myID)
                        .collection(cartItems)
                        .doc(product.id)
                        .update({
                      'count': value.get('count') - 1,
                    }),
                }
            });
    updateQuantity(myID: myID);
  }

  Stream cartStream({@required String myID}) {
    return firebaseFirestore.collection(cart).doc(myID).snapshots();
  }

  Stream cartItemsStream({@required String myID}) {
    return firebaseFirestore
        .collection(cart)
        .doc(myID)
        .collection(cartItems)
        .snapshots();
  }

  clearCart({@required String myID}) async {
    QuerySnapshot snapshot = await firebaseFirestore
        .collection(cart)
        .doc(myID)
        .collection(cartItems)
        .get();
    List<dynamic> listSnapshotItemCart = snapshot.docs;

    listSnapshotItemCart.forEach((element) {
      firebaseFirestore
          .collection(cart)
          .doc(myID)
          .collection(cartItems)
          .doc(element.data()['productID'])
          .delete();
    });
  }
}

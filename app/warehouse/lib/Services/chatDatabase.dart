import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDatabase {
  String chatrooms = 'chatrooms';
  String message = 'message';
  createChannel(String channelID, data) {
    FirebaseFirestore.instance
        .collection(chatrooms)
        .doc(channelID)
        .set(data)
        .catchError((e) {
      log(e.toString());
    });
  }

  Stream getChannel() {
    return FirebaseFirestore.instance
        .collection(chatrooms)
        .where('timeSend', isNull: false)
        .orderBy('timeSend', descending: true)
        .snapshots();
  }

  sendMessage(String channelID, data) {
    FirebaseFirestore.instance
        .collection(chatrooms)
        .doc(channelID)
        .collection(message)
        .add(data)
        .catchError((e) {
      log(e.message);
    });
    FirebaseFirestore.instance.collection(chatrooms).doc(channelID).set({
      "channelID": channelID,
      "message": data['message'],
      "sendBy": data['sendBy'],
      "timeSend": data['timeSend'],
      "unread": true,
    }).catchError((e) {
      log(e.message);
    });
  }

  Stream getMessage(String channelID) {
    return FirebaseFirestore.instance
        .collection(chatrooms)
        .doc(channelID)
        .collection(message)
        .orderBy('timeSend', descending: true)
        .snapshots();
  }

  readedSet(String channelID, String myselfID) {
    FirebaseFirestore.instance
        .collection(chatrooms)
        .doc(channelID)
        .get()
        .then((value) {
      if (value.data() != null) {
        if (myselfID != value.data()["sendBy"]) {
          FirebaseFirestore.instance
              .collection(chatrooms)
              .doc(channelID)
              .update({
            'unread': false,
          });
        }
      }
    });
  }
}

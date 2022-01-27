import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:warehouse/helper/actionToFile.dart';

class Storage {
  storage.Reference profileRef = storage.FirebaseStorage.instance.ref();

  Future<String> uploadImage(File file, String path) async {
    try {
      log('uploading...${file.path} to ${path}path');
      storage.TaskSnapshot snapshot =
          await profileRef.child(path).child(handleName(file)).putFile(file);
      String downloadUri =
          await profileRef.child(snapshot.ref.fullPath).getDownloadURL();
      return downloadUri + "|" + snapshot.ref.fullPath;
    } catch (e) {
      log(e.toString());
      return '';
    }
  }

  Future deleteImage(String path) async {
    await profileRef
        .child(path)
        .delete()
        .whenComplete(() => log('delete old image successful!.'));
  }
}

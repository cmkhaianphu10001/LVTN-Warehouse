import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:permission_handler/permission_handler.dart';

Future<String> saveImage({Uint8List imageFromScreenshot}) async {
  // await [Permission.storage].request();
  var result;
  try {
    result = await ImageGallerySaver.saveImage(
      imageFromScreenshot,
      name:
          'WarehouseQR ${DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-')}',
    );
  } catch (e) {
    log(e);
  }
  return result['filePath'];
}

Future saveAndShare({Uint8List imageFromScreenshot}) async {
  final directoty = await getApplicationDocumentsDirectory();
  final image = File('${directoty.path}/flutter.png');
  image.writeAsBytesSync(imageFromScreenshot);
  String text = 'QR from Warehouse';
  await Share.shareFiles([image.path], text: text);
}

String handleName(File file) {
  String rs = DateTime.now().microsecondsSinceEpoch.toString() + '-image';
  return rs;
}

String getdownloadUriFromDB(String data) {
  return data.split("|")[0];
}

String getFullpathFromDB(String data) {
  return data.split("|")[1];
}

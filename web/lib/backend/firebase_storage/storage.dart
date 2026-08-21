import 'dart:io';
import 'dart:typed_data';

import 'package:auto_deal_app/flutter_flow/upload_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime_type/mime_type.dart';

Future<String?> uploadData(String path, Uint8List data) async {
  final storageRef = FirebaseStorage.instance.ref().child(path);
  final metadata = SettableMetadata(contentType: mime(path));
  final result = await storageRef.putData(data, metadata);
  return result.state == TaskState.success ? result.ref.getDownloadURL() : null;
}

Future<String?> uploadFileToChat(String filePath, String chatId) async {
  final pickedMedia = File(filePath);
  String fileName = filePath.split('/').last;
  final mediaBytes = await pickedMedia.readAsBytes();
  final path = getStoragePath(chatId, fileName, false);
  final String? url = await uploadData(path, mediaBytes);
  return url;
}

Future<String?> uploadFileToChat2(String fileName, Uint8List data, String chatId) async {
  final path = getStoragePath(chatId, fileName, false);
  final String? url = await uploadData(path, data);
  return url;
}

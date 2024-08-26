import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:webrtc_chat/core/utils/helpers/functions.dart';

class StorageServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // UPLOAD FILE TO FIREBASE STORAGE

  Future<String> uploadFileToStorage(
      {required File file, required String path}) async {
    try {
      Uuid uuid = const Uuid();
      String ext = FileUtils.getFileExtension(file);
      Reference storageReference =
          _storage.ref(path).child("${uuid.v4()}.$ext");
      UploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.whenComplete(() => null);
      String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw e.toString();
    }
  }
}

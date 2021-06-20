import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class RepoStorage {
  static final FirebaseStorage firestore = FirebaseStorage.instance;

  late Reference _storageReference;

  Future<String?> uploadFile(File file) async {
    try {
      _storageReference = firestore.ref().child('${DateTime.now().millisecondsSinceEpoch}');

      UploadTask uploadTask = _storageReference.putFile(file);
      String url = await uploadTask.then((res) async {
        return await res.ref.getDownloadURL();
      });
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<bool> delete(String filePath) async {
    final ref = firestore.refFromURL(filePath);
    return await ref.delete().then((value) => true).catchError((e) => false);
  }

  Future<bool> updateFile(String filePath, File file) async {
    final ref = firestore.refFromURL(filePath);
    return await ref.putFile(file).then((value) => true).catchError((e) => false);
  }
}

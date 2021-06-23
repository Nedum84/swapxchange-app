import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swapxchange/utils/helpers.dart';

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

  Future<File?> downloadFileFromUrl(String url) async {
    String url = "https://graph.facebook.com/1752332884975552/picture";
    var tempDir = await getTemporaryDirectory();
    String savePath = tempDir.path + "/${Helpers.genRandString()}.jpg'";
    try {
      final response = await Dio().get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: true,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}

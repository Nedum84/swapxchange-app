import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/helpers.dart';

class RepoStorage {
  static final FirebaseStorage firestore = FirebaseStorage.instance;

  late Reference _storageReference;

  Future<String?> uploadFile(File file, String folder) async {
    if (folder != "") return cloudinaryUploadImage(file, folder);

    try {
      final filename = file.path;
      _storageReference = firestore.ref().child('$folder/$filename-${DateTime.now().millisecondsSinceEpoch}');

      UploadTask uploadTask = _storageReference.putFile(file);
      String url = await uploadTask.then((res) async {
        return await res.ref.getDownloadURL();
      });
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<bool> delete(String filePath, String folder) async {
    if (filePath.contains('cloudinary')) return deleteCloudinaryFile(filePath, folder);

    try {
      final ref = firestore.refFromURL(filePath);
      return await ref.delete().then((value) => true).catchError((e) => false);
    } catch (e) {
      return true;
    }
  }

  Future<bool> updateFile(String filePath, File file) async {
    final ref = firestore.refFromURL(filePath);
    return await ref.putFile(file).then((value) => true).catchError((e) => false);
  }

  Future<File?> downloadFileFromUrl(String url) async {
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
          },
        ),
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

  Future<String?> cloudinaryUploadImage(File file, String folder) async {
    final String url = "https://api.cloudinary.com/v1_1/${Constants.CLOUDINARY_CLOUD_NAME}/image/upload";

    var timestamp = DateTime.now().microsecondsSinceEpoch;
    final signature = getSignature("folder=$folder&timestamp=$timestamp");

    Dio dio = Dio();
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
      ),
      // "folder": folder,
      // "upload_preset": "vmbpmifp", //unsigned

      "api_key": Constants.CLOUDINARY_KEY,
      "folder": folder,
      "timestamp": timestamp,
      "signature": signature,
    });

    try {
      Response response = await dio.post(url, data: formData);

      var data = jsonDecode(response.toString());
      return data['secure_url'];
    } catch (e) {
      if (e is DioError) {
        print(e.response?.data);
      }
    }
  }

  Future<bool> deleteCloudinaryFile(String strUrl, String folder) async {
    final String url = "https://api.cloudinary.com/v1_1/${Constants.CLOUDINARY_CLOUD_NAME}/image/destroy";
    final String? pubId = getPublicId(strUrl, folder);
    if (pubId == null) return false;

    var timestamp = DateTime.now().microsecondsSinceEpoch;
    final signature = getSignature("public_id=$pubId&timestamp=$timestamp");

    Dio dio = Dio();
    FormData formData = new FormData.fromMap({
      "public_id": pubId,
      "api_key": Constants.CLOUDINARY_KEY,
      "timestamp": timestamp,
      "signature": signature,
    });
    try {
      Response response = await dio.post(url, data: formData);

      var data = jsonDecode(response.toString());
      return data['result'] == 'ok';
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data);
      }
    }
    return false;
  }

  String getSignature(String params) {
    final secret = Constants.CLOUDINARY_SECRET;
    var bytes = utf8.encode("$params$secret");

    var digest = sha1.convert(bytes);
    return digest.toString();
  }

  String? getPublicId(String url, String folder) {
    try {
      var str = url.split("/");

      final publicId = str.last.split(".")[0];
      return '$folder/$publicId';
    } catch (e) {
      print(e);
    }
  }
}

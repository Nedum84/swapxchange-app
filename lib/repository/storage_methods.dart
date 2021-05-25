import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RepoStorage {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late Reference _storageReference;

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      _storageReference = FirebaseStorage.instance.ref().child('${DateTime.now().millisecondsSinceEpoch}');

      UploadTask uploadTask = _storageReference.putFile(imageFile);
      String url = await uploadTask.then((res) async {
        return await res.ref.getDownloadURL();
      });
      return url;
    } catch (e) {
      return null;
    }
  }
  // uploadPic(File _image1) async {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   String url;
  //   Reference ref = storage.ref().child("image1" + DateTime.now().toString());
  //   UploadTask uploadTask = ref.putFile(_image1);
  //   uploadTask.whenComplete(() async{
  //     url = await ref.getDownloadURL();
  //   }).catchError((onError) {
  //     print(onError);
  //   });
  //
  //   return url;
  // }

  Future<String?> uploadImage({
    required String chatId,
    required File image,
    required String receiverId,
    required String senderId,
  }) async {
    // Get url from the image bucket
    return await uploadImageToStorage(image);
  }
}

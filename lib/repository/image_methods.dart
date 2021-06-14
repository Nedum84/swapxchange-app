import 'dart:convert';
import 'dart:io';

import 'package:swapxchange/repository/dio/api_client.dart';

class ImageMethods {
  static Future<String?> uploadSingleImage({required File imageFile}) async {
    String base64Image = base64Encode(imageFile.readAsBytesSync());

    final data = {
      "image_file": base64Image,
      "file_name": imageFile.path.split('/').last,
    };
    // Clipboard.setData(ClipboardData(text: base64Image));
    try {
      final response = await ApiClient.request().post('/image', data: data);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data["data"]["image_path"];
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}

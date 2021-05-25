import 'dart:io';
import 'dart:math';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Helpers {
  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];
    return firstNameInitial + lastNameInitial;
  }

  // Pick Image
  static Future<File?> pickImage({required ImageSource source}) async {
    var pickedImage = await ImagePicker().getImage(source: source);
    if (pickedImage != null) {
      var imgFile = File(pickedImage.path);
      return await compressImage(imgFile);
    } else {
      return null;
    }
  }

  static Future<File?> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    String rand = genRandString();

    String targetPath = '$path/sxc_$rand.jpg';
    var result = await FlutterImageCompress.compressAndGetFile(
      imageToCompress.absolute.path, targetPath,
      quality: 75,
      // rotate: 180,
      // rotate: 0,
      format: CompressFormat.jpeg,
    );

    return result;
  }

  static String formatDate(DateTime date) {
    var formatter = DateFormat.yMMMd();
    // var formatter = DateFormat('d MMM, yyyy'); //MMM-> Dec, MMMM-> December,
    // var formatter = DateFormat('dd/MM/yy');
    return formatter.format(date);
  }

  static String genRandString({int length = 15}) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    return getRandomString(length);
  }

  static String formatDistance({required double distance}) {
    if (distance < 100) {
      return (distance).toStringAsFixed(2) + "m"; //to 2 dp
    }
    return (distance / 1000).toStringAsFixed(2) + "km"; //to 2 dp
  }

  static String formatMoney({required int cash, bool withDot = true}) {
    final formatted = NumberFormat.currency(locale: "en_US", symbol: "").format(cash);
    if (!withDot) return formatted.replaceAll('.00', "");

    return formatted;
  }
}

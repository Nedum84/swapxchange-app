import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:swapxchange/utils/constants.dart';

class Encrypt {
  static encrypt(String plainText) {
    final rawKey = utf8.decode(base64.decode(Constants.RSA_PUBLIC_KEY));
    dynamic publicKey = RSAKeyParser().parse(rawKey);

    final encrypter = Encrypter(RSA(publicKey: publicKey, encoding: RSAEncoding.PKCS1));

    final encrypted = encrypter.encrypt(plainText);
    return encrypted.base64;
  }
}

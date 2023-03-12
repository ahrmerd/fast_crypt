library simple_encrypter;

import 'dart:convert';
import 'dart:io';

import 'package:fast_crypt/encryption/encryption_exception.dart';
import 'package:fast_crypt/encryption/xor_encrypt.dart';
import 'package:crypto/crypto.dart';

class SimpleEncrypter {
  static Future<void> encrypt(File file, String key,
      [bool replace = true]) async {
    try {
      final filename = file.path.split(Platform.pathSeparator).last;
      final parentdir = file.parent.path;
      if (!replace) {
        file = await file
            .copy(generateEncryptedFilePath(parentdir, filename, key));
      } else {
        file = await file
            .rename(generateEncryptedFilePath(parentdir, filename, key));
      }

      if ((await file.length()) < 100) {
        final contents = await file.readAsBytes();
        file.writeAsBytes(XOR.encrypt(contents, key));
      } else {
        var raFile = await file.open(mode: FileMode.append);
        raFile = await raFile.setPosition(0);
        final strtcont = await raFile.read(99);
        final encrypted = XOR.encrypt(strtcont, key);
        raFile = await raFile.setPosition(0);
        await raFile.writeFrom(encrypted);
        await raFile.close();
      }
    } on Exception {
      throw EncryptionException('Unable to encrypt');
    }
  }

  static Future<void> decrypt(File file, String key,
      [bool replace = true]) async {
    final filename = file.path.split(Platform.pathSeparator).last;
    final parentdir = file.parent.path;

    if (checkKey(filename, key)) {
      try {
        if (!replace) {
          file = await file
              .copy(generateDecryptedFilePath(parentdir, filename, key));
        } else {
          file = await file
              .rename(generateDecryptedFilePath(parentdir, filename, key));
        }
        if ((await file.length()) < 100) {
          final contents = await file.readAsBytes();
          file.writeAsBytes(XOR.decrypt(contents, key));
        } else {
          var raFile = await file.open(mode: FileMode.append);
          raFile = await raFile.setPosition(0);
          final strtcont = await raFile.read(99);
          final decrypted = XOR.decrypt(strtcont, key);
          raFile = await raFile.setPosition(0);
          await raFile.writeFrom(decrypted);
          await raFile.close();
        }
      } on Exception {
        throw EncryptionException('Unable to decrypt');
      }
    } else {
      throw CheckEncryptionKeyException();
    }
  }

  static String generateEncryptedFilePath(
      String parentdir, String filename, String key) {
    return addcheckDigit(
        '$parentdir${Platform.pathSeparator}${XOR.encrypt(filename.codeUnits, key).join('-')}',
        key);
  }

  static String generateDecryptedFilePath(
      String parentdir, String filename, String key) {
    return parentdir +
        Platform.pathSeparator +
        String.fromCharCodes(XOR.decrypt(
            filename
                .split('[')
                .first
                .split('-')
                .map((e) => int.parse(e))
                .toList(),
            key));
  }

  static String addcheckDigit(fileName, String key) {
    return '$fileName[${calculateCheck(key)}';
  }

  static String calculateCheck(String key) {
    final bytes = utf8.encode(key);
    return sha1.convert(bytes).toString().substring(0, 4);
  }

  static bool checkKey(String filename, String key) {
    try {
      String check = (filename.split('[').last);
      return calculateCheck(key) == check;
    } on FormatException {
      throw CheckEncryptionKeyException();
    }
  }
}

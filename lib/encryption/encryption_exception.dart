class EncryptionException implements Exception {
  final String _message;
  String get message => _message;

  EncryptionException([this._message = "Unable to Encrypt/Decrypt"]);
}

class CheckEncryptionKeyException extends EncryptionException {
  CheckEncryptionKeyException()
      : super('Your Key does not satify the check code');
}

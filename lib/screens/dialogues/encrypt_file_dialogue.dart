import 'dart:io';
import 'package:fast_crypt/encryption/encryption_exception.dart';
import 'package:fast_crypt/encryption/simple_encrypter.dart';
import 'package:fast_crypt/common/fonts.dart';
import 'package:fast_crypt/controllers/loading_controller.dart';
import 'package:fast_crypt/enums/processing_status.dart';
import 'package:fast_crypt/functions/filemanager.dart';
import 'package:fast_crypt/screens/utilities/error_screen.dart';
import 'package:fast_crypt/screens/utilities/loading.dart';
import 'package:fast_crypt/screens/utilities/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EncryptFileDialogue extends StatefulWidget {
  const EncryptFileDialogue({
    Key? key,
    this.entities,
    required this.files,
    // required this.controller,
  }) : super(key: key);

  final List<File> files;
  final List<FileSystemEntity>? entities;
  // final FileManagerController controller;

  @override
  State<EncryptFileDialogue> createState() => _EncryptFileDialogueState();
}

class _EncryptFileDialogueState extends State<EncryptFileDialogue> {
  late TextEditingController _encKeyController;
  late TextEditingController _encKeyConfirmController;
  ProcessingStatus _status = ProcessingStatus.initial;
  bool encrypt = true;
  String errorMessage = 'Unable to process the following files \n';

  @override
  void initState() {
    _encKeyController = TextEditingController();
    _encKeyConfirmController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Builder(builder: (context) {
        switch (_status) {
          case ProcessingStatus.initial:
            // TODO: Handle this case.
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // if (encrypt) Text('Encryption Mode') else Text('Decryption Mode'),
                  if (widget.entities != null && widget.entities!.isNotEmpty)
                    if (encrypt)
                      Text(
                        'You are Encrypting',
                        style: boldTextStyle,
                      )
                    else
                      Text(
                        'You are Decrypting',
                        style: boldTextStyle,
                      ),
                  if (widget.entities != null && widget.entities!.isNotEmpty)
                    Text(widget.entities!
                        .map((e) =>
                            (e is File ? "File: " : "Folder: ") +
                            fileEntityBasename(e))
                        .join(', ')),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('encrypt'),
                      SizedBox(width: 10),
                      Checkbox(
                          value: encrypt,
                          onChanged: (val) {
                            setState(() {
                              encrypt = val ?? true;
                            });
                          }),
                    ],
                  ),
                  ListTile(
                    title: TextField(
                      decoration: InputDecoration(label: Text('input key')),
                      controller: _encKeyController,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (encrypt)
                    ListTile(
                      title: TextField(
                        decoration: InputDecoration(label: Text('confirm key')),
                        controller: _encKeyConfirmController,
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          _status = ProcessingStatus.loading;
                        });
                        if (encrypt) {
                          if (_encKeyConfirmController.text ==
                              _encKeyController.text) {
                            await encryptFiles();
                          } else {
                            const snackBar = SnackBar(
                              content: Text('the two keys are not the same'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        } else {
                          await decryptFiles();
                        }
                        setState(() {
                          _status = ProcessingStatus.success;
                        });
                      } catch (e) {
                        setState(() {
                          _status = ProcessingStatus.error;
                        });
                      }

                      // Navigator.pop(context);
                    },
                    child: encrypt
                        ? const Text('Encrypt File/s or Folder/s')
                        : const Text('Decrypt File/s or Folder/s'),
                  )
                ],
              ),
            );
            break;
          case ProcessingStatus.success:
            return SuccessScreen(
              onReturn: () => Navigator.pop(context),
            );
            break;
          case ProcessingStatus.error:
            return ErrorScreen(
              description: errorMessage,
              onReturn: () {
                Navigator.pop(context);
              },
            );
            break;
          case ProcessingStatus.loading:
            return LoadingScreen();
            break;
        }
      }),
    );
  }

  Future<void> decryptFiles() async {
    LoadingController loadingController = Get.find();
    loadingController.startOperations(widget.files.length);
    var counter = [];
    // for (var i = 0; i < 20; i++) {
    // await Future.delayed(Duration(seconds: 1));
    loadingController.progress();
    // print(6);
    // }
    bool errorExist = false;
    for (var file in widget.files) {
      try {
        await SimpleEncrypter.decrypt(file, _encKeyController.text);
        loadingController.progress();
      } on CheckEncryptionKeyException catch (e) {
        errorExist = true;
        errorMessage += '|${fileEntityBasename(file)}:  ${e.message}|| \n';
      } on EncryptionException catch (e) {
        errorExist = true;
        errorMessage += '${fileEntityBasename(file)}:  ${e.message}|| ';
      } finally {}
    }
    if (errorExist) {
      throw EncryptionException();
    }
  }

  Future<void> encryptFiles() async {
    LoadingController loadingController = Get.find();

    loadingController.startOperations(widget.files.length);
    for (var file in widget.files) {
      await SimpleEncrypter.encrypt(file, _encKeyController.text);
      loadingController.progress();
    }
  }
}

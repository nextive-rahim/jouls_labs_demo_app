import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class HomeViewController extends GetxController {
  String? fileUrl;
  Future<File?> pickDocument() async {
    final pickedFile = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: [
          "pdf",
          'doc',
        ]);

    if (pickedFile == null) {
      return null;
    } else {
      final pickedDocument = pickedFile.files.first;
      fileUrl = pickedDocument.path;
      print("File Url : $fileUrl");
      return File(fileUrl ?? '');
    }
  }
}

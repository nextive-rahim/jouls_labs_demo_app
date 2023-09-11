import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jouls_labs_demo_app/sec/feature/authentication/controller/login_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/model/upload_file_model.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/widgets/db_helper.dart';

class HomeViewController extends GetxController {
  DBHelper dbHelper = DBHelper();
  final RxList<UploadedFileModel> file = <UploadedFileModel>[].obs;
  RxBool pdfUploadProgressIndicator = false.obs;
  RxBool loadingIndicator = false.obs;
  // Sqflite not support DateTime formate. So need to covert it int.
  int ms = (((DateTime.now()).millisecondsSinceEpoch) / 1000).round();
  Future<void> loadDocuments() async {
    loadingIndicator.value = true;
    final loadedDocuments = await dbHelper.getFiles();
    file.value = loadedDocuments;
    loadingIndicator.value = false;
  }

  User? user = FirebaseAuth.instance.currentUser;
  final userController = Get.find<LoginViewController>();
  String? fileUrl;
  Future<File?> pickDocument() async {
    final pickedFile = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: [
          "pdf",
        ]);

    if (pickedFile == null) {
      return null;
    } else {
      pdfUploadProgressIndicator.value = true;
      final pickedDocument = pickedFile.files.first;
      fileUrl = pickedDocument.path;

      UploadedFileModel fileModel = UploadedFileModel(
        id: 0,
        fileUrl: fileUrl,
        createdAt: ms,
        userName: user!.displayName,
        email: user!.email,
        profileImage: user!.photoURL,
      );

      await dbHelper.saveFiles(fileModel);
      await loadDocuments();
      pdfUploadProgressIndicator.value = false;
      return File(fileUrl ?? '');
    }
  }
}

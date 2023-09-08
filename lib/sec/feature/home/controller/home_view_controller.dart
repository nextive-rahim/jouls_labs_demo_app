import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:jouls_labs_demo_app/sec/feature/authentication/controller/login_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/model/upload_file_model.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/widgets/db_helper.dart';

class HomeViewController extends GetxController {
  DBHelper dbHelper = DBHelper();
  final RxList<UploadedFileModel> file = <UploadedFileModel>[].obs;
  RxBool isShowProgressIndicator = false.obs;
  Future<void> loadDocuments() async {
    final loadedDocuments = await dbHelper.getFiles();
    file.value = loadedDocuments;
  }

  final userController = Get.find<LoginViewController>();
  String? fileUrl;
  Future<File?> pickDocument() async {
    final pickedFile = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: [
          "pdf",
          'doc',
          'docx',
        ]);

    if (pickedFile == null) {
      return null;
    } else {
      final pickedDocument = pickedFile.files.first;
      fileUrl = pickedDocument.path;

      // Sqflite not support DateTime formate. So need to covert it int.
      int ms = (((DateTime.now()).millisecondsSinceEpoch) / 1000).round();

      UploadedFileModel fileModel = UploadedFileModel(
        id: 0,
        fileUrl: fileUrl,
        uploadTime: ms,
        userName: userController.userName,
        email: userController.email,
        profileImage: userController.profileImage,
      );
      isShowProgressIndicator.value = true;
      await dbHelper.saveFiles(fileModel);
      await loadDocuments();
      isShowProgressIndicator.value = false;
      return File(fileUrl ?? '');
    }
  }
}

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jouls_labs_demo_app/sec/feature/authentication/controller/login_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/model/upload_file_model.dart';
import 'package:jouls_labs_demo_app/sec/core/db_helper.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/widgets/moveable_stack_item.dart';

class HomeViewController extends GetxController {
  DBHelper dbHelper = DBHelper();
  final RxList<UploadedFileModel> file = <UploadedFileModel>[].obs;
  List<Widget> movableItems = [const MoveableStackItem()];
  final userController = Get.find<LoginViewController>();
  User? user = FirebaseAuth.instance.currentUser;
  String? fileUrl;
  Offset? offset;

  RxString editFilePath = ''.obs;
  RxBool isShowOriginalFile = false.obs;
  RxBool isSohowPosition = false.obs;
  RxBool pdfUploadProgressIndicator = false.obs;
  RxBool loadingIndicator = false.obs;

  RxDouble xPosition = 0.0.obs;
  RxDouble yPosition = 0.0.obs;

  RxBool isSavedFile = false.obs;
  RxBool isEditable = false.obs;

  Future<void> loadDocuments() async {
    loadingIndicator.value = true;
    final loadedDocuments = await dbHelper.getFiles();
    file.value = loadedDocuments;
    loadingIndicator.value = false;
  }

  Future<File?> pickDocument() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        "pdf",
      ],
    );

    if (pickedFile != null) {
      // Sqflite not support DateTime formate. So need to covert it int.
      int ms = (((DateTime.now()).millisecondsSinceEpoch) / 1000).round();
      pdfUploadProgressIndicator.value = true;
      final pickedDocument = pickedFile.files.first;
      fileUrl = pickedDocument.path;

      UploadedFileModel fileModel = UploadedFileModel(
        id: 0,
        fileName: '',
        fileUrl: fileUrl,
        createdAt: ms,
        userName: user!.displayName,
        email: user!.email,
        profileImage: user!.photoURL,
      );

      await dbHelper.saveFiles(fileModel).then((value) async {
        return await loadDocuments();
      });

      pdfUploadProgressIndicator.value = false;
      return File(fileUrl ?? '');
    }
    return null;
  }
}

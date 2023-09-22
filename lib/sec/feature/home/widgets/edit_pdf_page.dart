import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jouls_labs_demo_app/sec/core/db_helper.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/controller/home_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/colors.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/text_constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class EditPdfPage extends StatefulWidget {
  const EditPdfPage({super.key});

  @override
  _EditPdfPageState createState() => _EditPdfPageState();
}

class _EditPdfPageState extends State<EditPdfPage> {
  final controller = Get.put(HomeViewController());
  DBHelper db = DBHelper();
  final User? user = FirebaseAuth.instance.currentUser;
  String urlPDFPath = "";
  String title = "";
  bool exists = true;

  bool loaded = false;
  final homeController = Get.find<HomeViewController>();
  void requestPermission() async {
    await Permission.storage.request();
  }

  @override
  void initState() {
    requestPermission();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.loadDocuments();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.isEditable.value = false;
        // controller.isShowOriginalFile.value = false;
        controller.xPosition.value = 0.0;
        controller.yPosition.value = 0.0;
        controller.isSavedFile.value = false;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(TextConstants.editedFileInfo),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(10),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 700,
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  onPressed: () async {
                    controller.isShowOriginalFile.value =
                        !controller.isShowOriginalFile.value;
                    await controller.loadDocuments();
                  },
                  child: Obx(
                    () {
                      return Text(
                        controller.isShowOriginalFile.value
                            ? TextConstants.showEditFile
                            : TextConstants.originalFile,
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
                Obx(
                  () {
                    return Container(
                      height: 530,
                      child: SfPdfViewer.file(
                        controller.isShowOriginalFile.value
                            ? File(controller.file[0].fileUrl!)
                            : File(Get.arguments),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

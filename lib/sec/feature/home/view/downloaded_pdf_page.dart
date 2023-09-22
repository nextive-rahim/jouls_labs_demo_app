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

class DownloadedPdfPage extends StatefulWidget {
  const DownloadedPdfPage({super.key});

  @override
  _DownloadedPdfPageState createState() => _DownloadedPdfPageState();
}

class _DownloadedPdfPageState extends State<DownloadedPdfPage> {
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
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(TextConstants.editedFileInfo),
            centerTitle: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size(
                double.infinity,
                MediaQuery.of(context).viewPadding.top,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 35,
                      child: TabBar(
                          onTap: (int index) async {},
                          isScrollable: true,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          indicatorColor: Colors.red,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.white,
                          tabs: [
                            Container(child: Text(TextConstants.showEditFile)),
                            Text(TextConstants.originalFile),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: TabBarView(
              children: [
                Container(
                  height: 530,
                  child: SfPdfViewer.file(
                    File(Get.arguments),
                  ),
                ),

                Container(
                  height: 530,
                  child: SfPdfViewer.file(File(controller.file[0].fileUrl!)),
                )
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColors.primary),
                //   onPressed: () async {
                //     controller.isShowOriginalFile.value =
                //         !controller.isShowOriginalFile.value;
                //     await controller.loadDocuments();
                //   },
                //   child: Obx(
                //     () {
                //       return Text(
                //         controller.isShowOriginalFile.value
                //             ? TextConstants.showEditFile
                //             : TextConstants.originalFile,
                //       );
                //     },
                //   ),
                // ),
                // SizedBox(height: 15),
                // Obx(
                //   () {
                //     return Container(
                //       height: 530,
                //       child: SfPdfViewer.file(
                //         controller.isShowOriginalFile.value
                //             ? File(controller.file[0].fileUrl!)
                //             : File(Get.arguments),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

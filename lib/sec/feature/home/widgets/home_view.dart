import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/controller/home_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/widgets/pdf_card.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/colors.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/text_constants.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/time_converter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(HomeViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Obx(
              () {
                if (controller.pdfUploadProgressIndicator.value == true) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (controller.file.isEmpty) {
                  return const Center(
                    child: Offstage(),
                  );
                }
                final time = DateTime.fromMillisecondsSinceEpoch(
                        controller.file[0].createdAt! * 1000)
                    .toLocal();

                String fileName = controller.file[0].fileName == ''
                    ? controller.file[0].fileUrl!.split('/').last
                    : controller.file.first.fileName!;

                return Positioned(
                  top: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        TextConstants.fileMetaData,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text(
                            TextConstants.fileName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(fileName),
                        ],
                      ),
                      const SizedBox(height: 3),
                      controller.file.isNotEmpty
                          ? Row(
                              children: [
                                const Text(
                                  TextConstants.uploadedTime,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(" ${getFormattedTime(time).toString()}"),
                              ],
                            )
                          : const Offstage()
                    ],
                  ),
                );
              },
            ),
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                  height: 800,
                  color: AppColors.primary,
                  child: PdfViewer(
                    file: File(
                      '/storage/emulated/0/Android/data/com.example.jouls_labs_demo_app/files/edited_pdf.pdf',
                    ),
                  )),
            ),
            Obx(
              () {
                return Stack(children: [
                  Positioned(
                      top: controller.yPosition.value - 50,
                      left: controller.xPosition.value - 50,
                      child: Text('X=${controller.xPosition.value}'))
                ]

                    //  controller.isEditable.value == true
                    //     ? controller.movableItems
                    //     : List.empty(),
                    );
              },
            ),
            Obx(
              () {
                return Stack(children: [
                  Positioned(
                      top: controller.yPosition.value - 200,
                      left: controller.xPosition.value -200,
                      child: Text('Y=${controller.yPosition.value}'))
                ]

                    //  controller.isEditable.value == true
                    //     ? controller.movableItems
                    //     : List.empty(),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/controller/home_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/widgets/pdf_page.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/colors.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/text_constants.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/time_converter.dart';
import 'package:jouls_labs_demo_app/sec/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(HomeViewController());
  @override
  void initState() {
    // TODO: implement initState
    controller.loadDocuments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary),
                      onPressed: () {
                        controller.pickDocument();
                      },
                      child: const Text(TextConstants.uploadFile),
                    ),
                    const SizedBox(width: 20),
                    controller.pdfUploadProgressIndicator.value == true
                        ? SizedBox(
                            height: 35,
                            width: 35,
                            child: SpinKitFadingCircle(
                              itemBuilder: (BuildContext context, int index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: index.isEven
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox(
                            height: 35,
                            width: 35,
                          ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary),
                      onPressed: () {
                        Get.toNamed(
                          Routes.profile,
                          arguments: controller.file,
                        );
                      },
                      child: const Text(TextConstants.profile),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Obx(
                () {
                  if (controller.loadingIndicator.value == true) {
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
                          controller.file[0].uploadTime! * 1000)
                      .toLocal();

                  String fileName =
                      "File Name : ${controller.file[0].fileUrl!.split('/').last}";

                  return Column(
                    children: [
                      Row(
                        children: [
                          Column(
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
                              Text(
                                fileName,
                              ),
                              const SizedBox(height: 3),
                              controller.file.isNotEmpty
                                  ? Text(
                                      "Uploaded Time : ${getFormattedTime(time).toString()}")
                                  : const Offstage()
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        child: SizedBox(
                          height: 500,
                          child: controller.pdfUploadProgressIndicator.value ==
                                  true
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : PDFViewerWidget(
                                  pdfLink: controller.file[0].fileUrl!,
                                ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

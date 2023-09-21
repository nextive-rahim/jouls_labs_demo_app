import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/controller/home_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/core/db_helper.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/widgets/home_view.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/colors.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/text_constants.dart';
import 'package:jouls_labs_demo_app/sec/routes/app_routes.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final controller = Get.put(HomeViewController());
  DBHelper dbHelper = DBHelper();

  @override
  void initState() {
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
                () {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary),
                        onPressed: () {
                          controller.isEditable.value = false;
                          controller.xPosition.value = 0.0;
                          controller.yPosition.value = 0.0;
                          controller.isSavedFile.value = false;
                          controller.pickDocument();
                        },
                        child: const Text(TextConstants.uploadFile),
                      ),
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
                          : const Offstage(),
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
                      ),
                      controller.file.isNotEmpty
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary),
                              onPressed: () {
                                controller.isEditable.value = true;
                                print(controller.isEditable.value);
                              },
                              child: Text(
                                TextConstants.edit,
                              ),
                            )
                          : const Offstage(),
                    ],
                  );
                },
              ),
              Obx(
                () {
                  if (controller.file.isEmpty) {
                    return const Center(
                      child: Text(
                        'You have not uploaded any file',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          height: 640,
                          child: HomeView(),
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

  showDragAndDropImage() {
    controller.isEditable.value = true;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/controller/home_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/colors.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/text_constants.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/time_converter.dart';

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
      appBar: AppBar(
        title: const Text(TextConstants.homeAppBar),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            Row(
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
                Obx(
                  () => controller.isShowProgressIndicator.value == true
                      ? SpinKitFadingCircle(
                          itemBuilder: (BuildContext context, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                color: index.isEven ? Colors.red : Colors.green,
                              ),
                            );
                          },
                        )
                      : const Offstage(),
                )
              ], 
            ),
            Obx(() {
              final time = DateTime.fromMillisecondsSinceEpoch(
                      controller.file[0].uploadTime! * 1000)
                  .toLocal();
              return Column(
                children: [
                  Text(getFormattedTime(time).toString()),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}

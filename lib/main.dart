import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jouls_labs_demo_app/sec/feature/authentication/controller/login_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/controller/home_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/widgets/pdf_page.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/colors.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/text_constants.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/time_converter.dart';
import 'package:jouls_labs_demo_app/sec/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(LoginViewController());
    return GetMaterialApp(
      navigatorObservers: [RouteObserver<ModalRoute<void>>()],
      title: 'Jouls Labs',
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(HomeViewController());
  List<Widget> movableItems = [const MoveableStackItem()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 600,
        child: Stack(
          children: [
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

                String fileName = controller.file[0].fileUrl!.split('/').last;

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
                            "File Name :  ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            fileName,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      controller.file.isNotEmpty
                          ? Row(
                              children: [
                                const Text(
                                  "Uploaded Time : ",
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
            Obx(
              () => Positioned(
                top: 80,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 700,
                  width: 500,
                  color: Colors.blue,
                  child: controller.pdfUploadProgressIndicator.value == true
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : PDFViewerWidget(
                          pdfLink: controller.file[0].fileUrl!,
                        ),
                ),
              ),
            ),
            Stack(
              children: movableItems,
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(
      //       () {
      //         movableItems.add(
      //           const MoveableStackItem(),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}

class MoveableStackItem extends StatefulWidget {
  const MoveableStackItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MoveableStackItemState();
  }
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  double xPosition = 0.0;
  double yPosition = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(
            () {
              xPosition += tapInfo.delta.dx;
              yPosition += tapInfo.delta.dy;
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColors.primary,
          ),
          width: 120,
          height: 75,
          child: xPosition != 0.0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'X = $yPosition',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Y = $xPosition',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                    'Drag Me',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

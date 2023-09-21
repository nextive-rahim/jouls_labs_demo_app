// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jouls_labs_demo_app/sec/core/db_helper.dart';
// import 'package:jouls_labs_demo_app/sec/feature/home/controller/home_view_controller.dart';
// import 'package:jouls_labs_demo_app/sec/feature/home/widgets/pdf_card.dart';
// import 'package:jouls_labs_demo_app/sec/feature/utils/colors.dart';
// import 'package:jouls_labs_demo_app/sec/feature/utils/text_constants.dart';
// import 'package:permission_handler/permission_handler.dart';

// class EditPdfPage extends StatefulWidget {
//   const EditPdfPage({super.key});

//   @override
//   _EditPdfPageState createState() => _EditPdfPageState();
// }

// class _EditPdfPageState extends State<EditPdfPage> {
//   final controller = Get.put(HomeViewController());
//   DBHelper db = DBHelper();
//   final User? user = FirebaseAuth.instance.currentUser;
//   String urlPDFPath = "";
//   String title = "";
//   bool exists = true;

//   bool loaded = false;
//   final homeController = Get.find<HomeViewController>();
//   void requestPermission() async {
//     await Permission.storage.request();
//   }

//   @override
//   void initState() {
//     requestPermission();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.loadDocuments();
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (homeController.pdfUploadProgressIndicator.value == false) {
//       return WillPopScope(
//         onWillPop: () async {
//           controller.isEditable.value = false;
//           controller.xPosition.value = 0.0;
//           controller.yPosition.value = 0.0;
//           controller.isSavedFile.value = false;
//           return true;
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             centerTitle: true,
//             backgroundColor: AppColors.primary,
//             elevation: 0,
//             title: const Text(
//               TextConstants.editedFileInfo,
//             ),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Obx(
//               () {
//                 if (homeController.loadingIndicator.value == true) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 return SizedBox(
//                   height: MediaQuery.of(context).size.height,
//                   child: Stack(
//                     children: [
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primary),
//                         onPressed: () async {
//                           await controller.loadDocuments();
                           
//                         },
//                         child: const Text(TextConstants.profile),
//                       ),
//                       Obx(
//                         () {
//                           if (controller.pdfUploadProgressIndicator.value ==
//                               true) {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//                           if (controller.file.isEmpty) {
//                             return const Center(
//                               child: Offstage(),
//                             );
//                           }

//                           return Positioned(
//                             top: 0,
//                             right: 0,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [],
//                             ),
//                           );
//                         },
//                       ),
//                       Obx(
//                         () => Positioned(
//                           top: 80,
//                           left: 0,
//                           right: 0,
//                           bottom: 0,
//                           child: Container(
//                             height: 800,
//                             color: AppColors.primary,
//                             child: PDFViewerWidget(
//                               pdfLink: controller.file[0].fileUrl!,
//                             ),
//                           ),
//                         ),
//                       ),
//                       controller.loadingIndicator.value == true
//                           ? Offstage()
//                           : Stack(children: controller.movableItems)
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       );
//     } else {
//       //Replace with your loading UI
//       return const Center(
//         child: Text(
//           TextConstants.loading,
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       );
//     }
//   }
// }

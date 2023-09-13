import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/controller/home_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/colors.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/text_constants.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/time_converter.dart';
import 'package:permission_handler/permission_handler.dart';

class EditPdfPage extends StatefulWidget {
  const EditPdfPage({super.key});

  @override
  _EditPdfPageState createState() => _EditPdfPageState();
}

class _EditPdfPageState extends State<EditPdfPage> {
  final controller = Get.put(HomeViewController());
  final User? user = FirebaseAuth.instance.currentUser;
  String urlPDFPath = "";
  String title = "";
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController? _pdfViewController;
  bool loaded = false;
  final homeController = Get.find<HomeViewController>();
  void requestPermission() async {
    await Permission.storage.request();
  }

  @override
  void initState() {
    requestPermission();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String pdfLink = Get.arguments;
    final time = DateTime.fromMillisecondsSinceEpoch(
            controller.file[0].createdAt! * 1000)
        .toLocal();

    String fileName = controller.file[0].fileName == ''
        ? controller.file[0].fileUrl!.split('/').last
        : controller.file.first.fileName!;
    if (homeController.pdfUploadProgressIndicator.value == false) {
      return WillPopScope(
        onWillPop: () async {
          controller.isEditable.value = false;
          controller.xPosition.value = 0.0;
          controller.yPosition.value = 0.0;
          controller.isSavedFile.value = false;
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            title: const Text(
              TextConstants.editedFileInfo,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text(
                      TextConstants.editedAuthor,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user!.displayName ?? '',
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Text(
                      TextConstants.editedFileName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      fileName,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Text(
                      TextConstants.editedTime,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(" ${getFormattedTime(time).toString()}"),
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  child: SizedBox(
                    height: 450,
                    child: PDFView(
                      filePath: pdfLink,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: false,
                      fitPolicy: FitPolicy.BOTH,
                      onRender: (pages) {
                        setState(() {
                          _totalPages = pages!.toInt();
                          pdfReady = true;
                        });
                      },
                      onViewCreated: (PDFViewController vc) {
                        setState(() {
                          _pdfViewController = vc;
                        });
                      },
                      onPageChanged: (int? page, int? total) {
                        setState(() {
                          _currentPage = page!.toInt();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildPageNavigation(),
        ),
      );
    } else {
      //Replace with your loading UI
      return const Center(
        child: Text(
          TextConstants.loading,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  Container _buildPageNavigation() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
        bottom: 20,
        left: 20,
        right: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 41,
            width: 130,
            child: TextFormField(
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
              onChanged: (page) {
                if (int.parse(page) > 0) {
                  _pdfViewController!.setPage(
                    int.parse(page),
                  );
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  top: 10,
                  right: 20,
                  bottom: 10,
                  left: 20,
                ),
                isDense: true,
                hintText: 'Page Number',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: Colors.black38,
                ),
                fillColor: Colors.transparent,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                iconSize: 50,
                color: AppColors.primary,
                onPressed: () {
                  setState(
                    () {
                      if (_currentPage > 0) {
                        _currentPage--;
                        _pdfViewController!.setPage(_currentPage);
                      }
                    },
                  );
                },
              ),
              Text(
                "${_currentPage + 1} / $_totalPages",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                iconSize: 50,
                color: AppColors.primary,
                onPressed: () {
                  setState(
                    () {
                      if (_currentPage < _totalPages - 1) {
                        _currentPage++;
                        _pdfViewController!.setPage(_currentPage);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

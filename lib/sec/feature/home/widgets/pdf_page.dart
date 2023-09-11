import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/controller/home_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/colors.dart';
import 'package:permission_handler/permission_handler.dart';

// class EditPdfScreen extends StatefulWidget {
//   const EditPdfScreen({
//     super.key,
//     //required this.pdfLink,
//   });

//   @override
//   State<EditPdfScreen> createState() => _EditPdfScreenState();
// }

// class _EditPdfScreenState extends State<EditPdfScreen> {
//   final String pdfLink = Get.arguments;
//   @override
//   void initState() {
//     editPdf();

//     super.initState();
//   }

//   void editPdf() async {
//     await Pspdfkit.present(pdfLink);
//     await Permission.storage.request();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('widget.title'),
//       ),
//       body: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[],
//         ),
//       ),
//     );
//   }
// }

class PDFViewerWidget extends StatefulWidget {
  final String pdfLink;

  const PDFViewerWidget({
    super.key,
    required this.pdfLink,
  });

  @override
  _PDFViewerWidgetState createState() => _PDFViewerWidgetState();
}

class _PDFViewerWidgetState extends State<PDFViewerWidget> {
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
    // await Pspdfkit.present(widget.pdfLink);
    await Permission.storage.request();
  }

  @override
  void initState() {
    requestPermission();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (homeController.pdfUploadProgressIndicator.value == false) {
      return Scaffold(
        body: PDFView(
          filePath: widget.pdfLink,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: false,
          pageFling: true,
          pageSnap: true,
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
        bottomNavigationBar: _buildPageNavigation(),
      );
    } else {
      if (exists) {
        //Replace with your loading UI
        return const Center(
          child: Text(
            "Loading..",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        //Replace Error UI
        return const Text(
          "PDF Not Available",
          style: TextStyle(fontSize: 20),
        );
      }
    }
  }

  Container _buildPageNavigation() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(00),
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
                  _pdfViewController!.setPage(int.parse(page));
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
                  fontFamily: 'Poppins',
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

import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/controller/home_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/colors.dart';

class MoveableStackItem extends StatefulWidget {
  const MoveableStackItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MoveableStackItemState();
  }
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  final controller = Get.put(HomeViewController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Positioned(
        top: controller.yPosition.value,
        left: controller.xPosition.value,
        child: GestureDetector(
          onPanUpdate: (tapInfo) {
            setState(
              () {
                controller.xPosition.value += tapInfo.delta.dx;
                controller.yPosition.value += tapInfo.delta.dy;
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
            child: Material(
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSl7Cadho1YF1TCFZRfanGSwIxnklacJPtiycrPEgtw&s',
                height: 100,
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
    });
  }
}

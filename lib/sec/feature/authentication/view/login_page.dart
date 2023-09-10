import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:jouls_labs_demo_app/sec/feature/authentication/controller/login_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/colors.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/text_constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = Get.put(LoginViewController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller.checkSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        onPressed: () {
          controller.checkSignIn();
        },
        child: const Text(TextConstants.login),
      )),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:jouls_labs_demo_app/sec/feature/authentication/controller/login_view_controller.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/model/upload_file_model.dart';
import 'package:jouls_labs_demo_app/sec/core/db_helper.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/assets.dart';
import 'package:jouls_labs_demo_app/sec/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

DBHelper dbHelper = DBHelper();
List<UploadedFileModel> file = <UploadedFileModel>[];

User? user;

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Get.put(LoginViewController());
    user = FirebaseAuth.instance.currentUser;

    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    Future.delayed(const Duration(seconds: 2)).then(
      (value) {
        if (user != null) {
          if (user!.emailVerified) {
            return Get.offNamed(Routes.home);
          }
        }
        return Get.offNamed(Routes.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: _buildLogo(),
        ),
      ),
    );
  }

  Column _buildLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Assets.appLogo)
        // SpinKitFadingCircle(
        //   itemBuilder: (BuildContext context, int index) {
        //     return DecoratedBox(
        //       decoration: BoxDecoration(
        //         color: index.isEven ? Colors.red : Colors.green,
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }
}

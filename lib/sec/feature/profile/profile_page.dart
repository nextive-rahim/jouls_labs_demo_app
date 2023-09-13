import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:jouls_labs_demo_app/sec/feature/home/model/upload_file_model.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/colors.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/text_constants.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final List<UploadedFileModel> sqfliteUser = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text(TextConstants.profile),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    sqfliteUser.isNotEmpty
                        ? sqfliteUser.first.profileImage!
                        : firebaseUser!.photoURL!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  sqfliteUser.isNotEmpty
                      ? sqfliteUser.first.userName!
                      : firebaseUser!.displayName!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(sqfliteUser.isNotEmpty
                    ? sqfliteUser.first.email!
                    : firebaseUser!.email!),
              ],
            )
          ],
        ),
      ),
    );
  }
}

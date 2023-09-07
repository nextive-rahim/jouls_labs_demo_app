import 'package:flutter/material.dart';
import 'package:jouls_labs_demo_app/sec/feature/utils/text_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TextConstants.homeAppBar),
      ),
    );
  }
}

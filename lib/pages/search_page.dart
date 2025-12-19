import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GetX Audio Player")),
      body: Center(
        child: TextButton(
          onPressed: () {
            Get.snackbar("test", "test", snackPosition: SnackPosition.TOP);
          },
          child: const Text("test"),
        ),
      ),
    );
  }
}

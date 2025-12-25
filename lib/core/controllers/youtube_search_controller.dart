import 'package:get/get.dart';
import 'package:flutter/material.dart';

class YoutubeSearchController extends GetxController {
  final searchController = TextEditingController();

  final isEditing = false.obs;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

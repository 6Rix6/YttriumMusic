import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:yttrium_music/common/controllers/count_controller.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final countColtroller = Get.put(CounterController());
    return Scaffold(
      appBar: AppBar(title: const Text('Library Page')),
      body: Center(
        child: TextButton(
          onPressed: () => Get.to(() => OtherPage()),
          child: const Text('Go to Other Page'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: countColtroller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final countColtroller = Get.find<CounterController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Page'),
        leading: TextButton(
          onPressed: () => Get.back(),
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(child: Obx(() => Text(countColtroller.count.toString()))),
      floatingActionButton: FloatingActionButton(
        onPressed: countColtroller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}

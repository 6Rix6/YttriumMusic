import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:yttrium_music/common/controllers/auth_controller.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 12,
          children: [
            const Icon(
              CupertinoIcons.arrowtriangle_right_circle_fill,
              size: 28,
            ),
            const Text('Music', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
            onPressed: () => context.push('/search'),
          ),
          Obx(() {
            final icon = authController.isLoggedIn.value
                ? Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          authController.accountPhotoUrl.value,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const Icon(CupertinoIcons.person);
            return IconButton(
              icon: icon,
              onPressed: () => context.push('/setting'),
            );
          }),
        ],
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      body: Center(child: Text("library")),
    );
  }
}

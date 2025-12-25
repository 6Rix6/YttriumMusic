import 'package:get/get.dart';
import 'package:yttrium_music/core/services/storage_service.dart';

class AuthController extends GetxController {
  final StorageService storageService;

  AuthController({required this.storageService});

  final cookie = ''.obs;
  final isLoggedIn = false.obs;
  final Rx<String> accountName = ''.obs;
  final Rx<String> accountHandle = ''.obs;
  final Rx<String> accountPhotoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedAccount();
  }

  void loadSavedAccount() {
    cookie.value = storageService.readString('cookie') ?? '';
    isLoggedIn.value = storageService.readBool('isLogin', defaultValue: false);
    accountName.value = storageService.readString('accountName') ?? '';
    accountHandle.value = storageService.readString('accountHandle') ?? '';
    accountPhotoUrl.value = storageService.readString('accountPhotoUrl') ?? '';
  }

  Future<void> login({
    required String cookie,
    required String accountName,
    required String accountHandle,
    String? accountPhotoUrl,
  }) async {
    await setCookie(cookie);
    await setAccount(accountName, accountHandle, accountPhotoUrl ?? '');
    await setIsLogin(true);
  }

  Future<void> logout() async {
    await setIsLogin(false);
    await setCookie('');
    await setAccount('', '', '');
  }

  Future<void> setCookie(String value) async {
    cookie.value = value;
    await storageService.writeString('cookie', value);
  }

  Future<void> setIsLogin(bool value) async {
    isLoggedIn.value = value;
    await storageService.writeBool('isLogin', value);
  }

  Future<void> setAccount(String name, String handle, String photoUrl) async {
    accountName.value = name;
    accountHandle.value = handle;
    accountPhotoUrl.value = photoUrl;
    await storageService.writeString('accountName', name);
    await storageService.writeString('accountHandle', handle);
    await storageService.writeString('accountPhotoUrl', photoUrl);
  }
}

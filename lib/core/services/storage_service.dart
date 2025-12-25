import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  String? readString(String key) {
    return _prefs.getString(key);
  }

  Future<void> writeString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  bool readBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<void> writeBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }
}

import 'package:get/get.dart';

// 1. GetxControllerを継承
class CounterController extends GetxController {
  // 2. 監視可能な(Reactive)な変数を作成
  // .obsを付けることで、この変数が変更されたときにウィジェットを更新するようにGetXに伝えます。
  var count = 0.obs;

  // 3. ステートを変更するメソッド
  void increment() {
    count.value++;
    // update()を呼ぶ必要はありません。
  }
}

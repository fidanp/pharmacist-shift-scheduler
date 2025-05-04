import 'package:get/get.dart';

import '../controllers/shift_scheduler_controller.dart';

class InputScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShiftSchedulerScreenController>(
      () => ShiftSchedulerScreenController(),
    );
  }
}

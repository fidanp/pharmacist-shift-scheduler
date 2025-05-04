// bindings/initial_binding.dart

import 'package:get/get.dart';
import 'package:pharmacist/app/modules/Summary/controllers/summary_controller.dart';
import 'package:pharmacist/app/modules/Schedule/controllers/schedule_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SummaryController>(SummaryController(), permanent: true);
    Get.put<ScheduleController>(ScheduleController(), permanent: true);
  }
}

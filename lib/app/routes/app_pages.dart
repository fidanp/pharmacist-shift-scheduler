import 'package:get/get.dart';
import 'package:pharmacist/app/modules/Home/views/home_view.dart';
import 'package:pharmacist/app/modules/ShiftScheduler/bindings/shift_scheduler_binding.dart';
import 'package:pharmacist/app/modules/Schedule/bindings/schedule_binding.dart';
import 'package:pharmacist/app/modules/Summary/bindings/summary_binding.dart';

import '../modules/ShiftScheduler/views/shift_scheduler_view.dart';
import '../modules/Schedule/views/schedule_view.dart';
import '../modules/Summary/views/summary_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.HOME_WRAPPER,
      page: () => HomeWrapper(),
      participatesInRootNavigator: true,
      children: [
        GetPage(
          name: Routes.INPUT_SCREEN,
          page: () => const ShiftSchedulerView(),
          binding: InputScreenBinding(),
        ),
        GetPage(
          name: Routes.SCHEDULE,
          page: () => const ScheduleView(),
          binding: ScheduleBinding(),
        ),
        GetPage(
          name: Routes.SUMMARY,
          page: () => const SummaryView(),
          binding: SummaryBinding(),
        ),
      ],
    ),
  ];
}


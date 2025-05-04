import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global/controllers/bottom_nav_controller.dart';
import '../../../routes/app_routes.dart';
import '../../Schedule/controllers/schedule_controller.dart';

class HomeWrapper extends StatelessWidget {
  final BottomNavController bottomNavController = Get.put(BottomNavController());
  final scheduleController = Get.put(ScheduleController());


  final List<String> routeTabs = [
    Routes.INPUT_SCREEN,
    Routes.SCHEDULE,
    Routes.SUMMARY,
  ];

   HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() => Scaffold(
          body: GetRouterOutlet(
            initialRoute: Routes.INPUT_SCREEN,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: bottomNavController.selectedIndex.value,
            onTap: (index) {
              bottomNavController.updateIndex(index);
              Get.rootDelegate.toNamed(routeTabs[index]);
            },
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: theme.colorScheme.tertiary,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'home'.tr),
              BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'schedule'.tr),
              BottomNavigationBarItem(icon: Icon(Icons.summarize), label: 'summary'.tr),
            ],
          ),
        ));
  }
}

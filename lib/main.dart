import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmacist/app/global/bindings/initial_binding.dart';
import 'package:pharmacist/app/routes/app_routes.dart';

import 'app/routes/app_pages.dart';
import 'app/theme/theme.dart';
import 'app/theme/theme_controller.dart';
import 'data/model/daily_schedule.dart';
import 'data/model/pharmacist_summary.dart';
import 'generated/locales.g.dart';
import 'app/global/controllers/language_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(DailyScheduleAdapter());
  Hive.registerAdapter(PharmacistSummaryAdapter());
  // Hive.deleteBoxFromDisk('schedules');
  // Hive.deleteBoxFromDisk( 'summaries');

  await Hive.openBox<DailySchedule>('schedules');
  await Hive.openBox<PharmacistSummary>('summaries');
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ThemeController themeController;
  late final LanguageController languageController;

  @override
  void initState() {
    super.initState();
    themeController = Get.put(ThemeController(), permanent: true);
    languageController = Get.put(LanguageController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Az eWallet',
        theme: themeController.isDarkMode.value ? darkTheme : lightTheme,
        translationsKeys: AppTranslation.translations,
        fallbackLocale: const Locale('en'),
        locale: Locale(languageController.selectedLanguage.value),
        initialBinding: InitialBinding(),
        initialRoute: Routes.HOME_WRAPPER,
        getPages: AppPages.routes, 
        navigatorKey: Get.key,
      ),
    );
  }
}

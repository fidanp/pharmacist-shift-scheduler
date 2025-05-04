import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pharmacist/data/model/daily_schedule.dart';

class ScheduleController extends GetxController {
  final count = 0.obs;
  final RxMap<DateTime, DailySchedule> schedule = <DateTime, DailySchedule>{}.obs;

    // Move these from the view into the controller
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rxn<DateTime> selectedDay = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    loadScheduleFromHive();
  }

  void loadScheduleFromHive() async {
    final box = await Hive.openBox<DailySchedule>('schedules');
    final Map<DateTime, DailySchedule> loadedData = {};

    for (var key in box.keys) {
      final dailySchedule = box.get(key);
      if (dailySchedule != null) {
        loadedData[dailySchedule.date] = dailySchedule;
      }
    }

    schedule.value = loadedData;  // Assign the loaded data to the RxMap
  }

  void setSchedule(Map<DateTime, DailySchedule> newSchedule) async {
    final box = await Hive.openBox<DailySchedule>('schedules');

    newSchedule.forEach((date, dailySchedule) {
      box.put(date.toIso8601String(), dailySchedule);
    });

    schedule.value = newSchedule;  // Update the schedule RxMap
  }

  void clearSchedule() async {
    final box = await Hive.openBox<DailySchedule>('schedules');
    schedule.clear();
    box.clear();
  }

Map<String, List<String>> getPharmacistsByShift(DateTime date) {
  final normalizedDate = DateTime(date.year, date.month, date.day);
  final dailySchedule = schedule[normalizedDate];

  if (dailySchedule == null) {
    return {
      'Morning': [],
      'Afternoon': [],
      'Evening': [],
    };
  }

  final shift = dailySchedule.shift;
  final pharmacists = dailySchedule.pharmacists;

  return {
    'Morning': shift == 'Morning' ? pharmacists : [],
    'Afternoon': shift == 'Afternoon' ? pharmacists : [],
    'Evening': shift == 'Evening' ? pharmacists : [],
  };
}




  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    clearSchedule();
    super.onClose();
  }
}

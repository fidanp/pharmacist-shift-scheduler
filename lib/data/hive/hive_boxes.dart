import 'package:hive/hive.dart';

import '../model/daily_schedule.dart';
import '../model/pharmacist_summary.dart';


class HiveBoxes {
  static const String schedulesBoxName = 'schedules';
  static const String summariesBoxName = 'summaries';

  static Box<DailySchedule> getSchedulesBox() => Hive.box<DailySchedule>(schedulesBoxName);
  static Box<PharmacistSummary> getSummariesBox() => Hive.box<PharmacistSummary>(summariesBoxName);
}

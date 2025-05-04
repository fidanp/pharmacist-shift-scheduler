import 'package:hive/hive.dart';

part 'daily_schedule.g.dart';

@HiveType(typeId: 0)
class DailySchedule extends HiveObject {
  @HiveField(0)
  late DateTime date;

  @HiveField(1)
  late String shift; // Morning, Afternoon, or Evening

  @HiveField(2)
  late List<String> pharmacists;

  DailySchedule({
    required this.date,
    required this.shift,
    required this.pharmacists,
  });
}

import 'package:hive/hive.dart';

part 'pharmacist_summary.g.dart';

@HiveType(typeId: 1)
class PharmacistSummary extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late int total;

  @HiveField(2)
  late int morning;

  @HiveField(3)
  late int afternoon;

  @HiveField(4)
  late int evening;

  @HiveField(5)
  late int weekend;

  PharmacistSummary({
    required this.name,
    required this.total,
    required this.morning,
    required this.afternoon,
    required this.evening,
    required this.weekend,
  });
}

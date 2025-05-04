import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmacist/app/modules/Summary/controllers/summary_controller.dart';

import '../../../../data/hive/hive_boxes.dart';
import '../../../../data/model/daily_schedule.dart';
import '../../../../data/model/pharmacist_summary.dart';
import '../../../global/controllers/bottom_nav_controller.dart';
import '../../../routes/app_routes.dart';
import '../../Schedule/controllers/schedule_controller.dart';
import 'shift_scheduler.dart';


class ShiftSchedulerScreenController extends GetxController {
  var selectedDate = DateTime.now().obs;
  final pharmacistCountController = TextEditingController();
  final pharmacistNameController = TextEditingController();
  final count = 0.obs;

  final ScheduleController scheduleController = Get.find();
  final SummaryController summaryController = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    pharmacistCountController.dispose();
    super.onClose();
  }
  // get names from textfield
  getPharmacistNames() {
    List<String> pharmacistNames =
        pharmacistNameController.text
            .split('\n')
            .map((name) => name.trim())
            .where((name) => name.isNotEmpty)
            .toList();

    print(pharmacistNames);
  }
  //import names from excel
  Future<void> importNamesFromExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.single.bytes;

      if (fileBytes == null && result.files.single.path != null) {
        fileBytes = await File(result.files.single.path!).readAsBytes();
      }

      if (fileBytes == null) {
        Get.snackbar(
          'error'.tr,
          'couldNotReadExcelFile'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final excel = Excel.decodeBytes(fileBytes);

      List<String> names = [];

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          if (row.isNotEmpty && row[0] != null) {
            final name = row[0]!.value.toString().trim();
            if (name.isNotEmpty) names.add(name);
          }
        }
      }

      final existingText = pharmacistNameController.text;
      final newText = (existingText + '\n' + names.join('\n')).trim();
      pharmacistNameController.text = newText;
    } else {
      Get.snackbar(
        'error'.tr,
        'noFileSelectedOrInvalidFile'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  //generate shifts
  generateShiftSchedule() async {
    final rawText = pharmacistNameController.text.trim();
    if (rawText.isEmpty) {
      Get.snackbar("Error", "Please enter pharmacist names.");
      return;
    }

    final pharmacists = rawText
        .split('\n')
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    if (pharmacists.length < 3) {
      Get.snackbar("Error", "At least 3 pharmacists are required.");
      return;
    }

    final date = selectedDate.value;
    final year = date.year;
    final month = date.month;
    final daysInMonth = DateUtils.getDaysInMonth(year, month);

    final scheduler = ShiftScheduler(
      pharmacists: pharmacists,
      year: year,
      month: month,
      daysInMonth: daysInMonth,
    );

    final schedule = await scheduler.generateSchedule();
    final schedulesBox = HiveBoxes.getSchedulesBox();
    await schedulesBox.clear();

    // Save daily schedules
    for (var entry in schedule.entries) {
      final date = entry.key;
      final shiftAssignments = entry.value;
      final dailySchedule = DailySchedule(
        date: date,
        shift: shiftAssignments.toString(),
        pharmacists: shiftAssignments.values.expand((e) => e).toList(),
      );
      await schedulesBox.add(dailySchedule);
    }

    // Save shift summaries
    final summariesBox = HiveBoxes.getSummariesBox();
    await summariesBox.clear();

    for (var pharmacist in pharmacists) {
      final summary = PharmacistSummary(
        name: pharmacist,
        total: scheduler.shiftCounts[pharmacist]!['TotalShifts']!,
        morning: scheduler.shiftCounts[pharmacist]!['Morning']!,
        afternoon: scheduler.shiftCounts[pharmacist]!['Afternoon']!,
        evening: scheduler.shiftCounts[pharmacist]!['Evening']!,
        weekend: scheduler.shiftCounts[pharmacist]!['Weekend']!,
      );
      await summariesBox.add(summary);
    }

    // Prepare structured format for the controller
    final Map<DateTime, DailySchedule> formattedSchedule = {};
    for (var entry in schedule.entries) {
      final date = entry.key;
      final shiftAssignments = entry.value;
      final dailySchedule = DailySchedule(
        date: date,
        shift: shiftAssignments.toString(),
        pharmacists: shiftAssignments.values.expand((e) => e).toList(),
      );
      formattedSchedule[date] = dailySchedule;
    }

    scheduleController.setSchedule(formattedSchedule);
    summaryController.setSummary(scheduler.shiftCounts);

    BottomNavController().updateIndex(1);

    Get.rootDelegate.toNamed(Routes.SCHEDULE);
  }
} 
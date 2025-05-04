import 'dart:math';

class ShiftScheduler {
  final List<String> pharmacists;
  final int year;
  final int month;
  final int daysInMonth;
  final List<String> shiftTypes;
  final Random random;
  late final Map<String, Map<String, int>> shiftCounts;

  ShiftScheduler({
    required this.pharmacists,
    required this.year,
    required this.month,
    required this.daysInMonth,
    this.shiftTypes = const ['Morning', 'Afternoon', 'Evening'],
  }) : random = Random() {
    shiftCounts = _initializeShiftCounts();
  }

  Map<String, Map<String, int>> _initializeShiftCounts() {
    return {
      for (var p in pharmacists)
        p: {
          'Morning': 0,
          'Afternoon': 0,
          'Evening': 0,
          'Weekend': 0,
          'TotalShifts': 0,
          'DaysWorked': 0,
        }
    };
  }

  Map<String, int> _calculateTargets() {
    final totalShifts = daysInMonth * shiftTypes.length;
    return {
      'shiftsPerPharmacist': totalShifts ~/ pharmacists.length,
      'daysPerPharmacist': (daysInMonth * 3) ~/ pharmacists.length,
      'shiftsPerType': (totalShifts ~/ pharmacists.length) ~/ 3,
      'remainingShifts': totalShifts % pharmacists.length,
    };
  }

  List<String> _sortShiftTypesByDistribution(Map<String, Map<String, int>> shiftCounts) {
    return List.from(shiftTypes)
      ..sort((a, b) {
        final aCount = shiftCounts.values.fold(0, (sum, p) => sum + p[a]!);
        final bCount = shiftCounts.values.fold(0, (sum, p) => sum + p[b]!);
        return aCount.compareTo(bCount);
      });
  }
  Map<String, dynamic> _assignPharmacistsToShift(
  String shift,
  int pharmacistsPerShift,
  Map<String, Map<String, int>> shiftCounts,
  Set<String> assignedToday,
  int currentIndex,
  bool isWeekend, // <-- add this
) {
  final assignments = <String>[];
  var index = currentIndex;
  var attempts = 0;

  while (assignments.length < pharmacistsPerShift && attempts < pharmacists.length * 2) {
    final pharmacist = pharmacists[index];

    if (!assignedToday.contains(pharmacist)) {
      assignments.add(pharmacist);
      assignedToday.add(pharmacist);

      shiftCounts[pharmacist]![shift] = shiftCounts[pharmacist]![shift]! + 1;
      shiftCounts[pharmacist]!['TotalShifts'] = shiftCounts[pharmacist]!['TotalShifts']! + 1;
      shiftCounts[pharmacist]!['DaysWorked'] = shiftCounts[pharmacist]!['DaysWorked']! + 1;

      if (isWeekend) {
        shiftCounts[pharmacist]!['Weekend'] = shiftCounts[pharmacist]!['Weekend']! + 1;
      }
    }

    index = (index + 1) % pharmacists.length;
    attempts++;
  }

  return {
    'assignments': assignments,
    'nextIndex': index,
  };
}

  void _handleUnassignedPharmacists(
    List<String> unassigned,
    Map<String, List<String>> shiftAssignments,
    Map<String, Map<String, int>> shiftCounts,
    int pharmacistsPerShift,
    bool isWeekend,
  ) {
    for (var p in unassigned) {
      final availableShifts = shiftTypes.where((shift) => 
          shiftAssignments[shift]!.length < pharmacistsPerShift).toList();

      if (availableShifts.isNotEmpty) {
        availableShifts.sort((a, b) => 
            shiftCounts[p]![a]!.compareTo(shiftCounts[p]![b]!));
        
        final selectedShift = availableShifts.first;
        shiftAssignments[selectedShift]!.add(p);
        shiftCounts[p]![selectedShift] = shiftCounts[p]![selectedShift]! + 1;
        shiftCounts[p]!['TotalShifts'] = shiftCounts[p]!['TotalShifts']! + 1;
        shiftCounts[p]!['DaysWorked'] = shiftCounts[p]!['DaysWorked']! + 1;

        if (isWeekend) {
          shiftCounts[p]!['Weekend'] = shiftCounts[p]!['Weekend']! + 1;
        }
      }
    }
  }

  Future<Map<DateTime, Map<String, List<String>>>> generateSchedule() async {
    final targets = _calculateTargets();
    final schedule = <DateTime, Map<String, List<String>>>{};
    final shiftIndices = {
      for (var shift in shiftTypes) shift: 0,
    };

    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(year, month, day);
      final isWeekend = currentDate.weekday == DateTime.saturday || currentDate.weekday == DateTime.sunday;
      final assignedToday = <String>{};
      final shiftAssignments = <String, List<String>>{
        for (var shift in shiftTypes) shift: [],
      };

      final pharmacistsPerShift = (pharmacists.length / shiftTypes.length).ceil();
      final sortedShiftTypes = _sortShiftTypesByDistribution(shiftCounts);

      for (var shift in sortedShiftTypes) {
        final result = _assignPharmacistsToShift(
          shift,
          pharmacistsPerShift,
          shiftCounts,
          assignedToday,
          shiftIndices[shift]!,
          isWeekend
        );
        shiftAssignments[shift]!.addAll(result['assignments']!);
        shiftIndices[shift] = result['nextIndex']!;
      }

      final unassigned = pharmacists.where((p) => !assignedToday.contains(p)).toList();
      _handleUnassignedPharmacists(
        unassigned,
        shiftAssignments,
        shiftCounts,
        pharmacistsPerShift,
        isWeekend,
      );

      schedule[currentDate] = shiftAssignments;
    }

    return schedule;
  }
}

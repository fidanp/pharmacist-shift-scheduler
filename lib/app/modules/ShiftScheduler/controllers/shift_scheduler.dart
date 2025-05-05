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
        },
    };
  }

  // List<String> _sortPharmacistsByShiftCount(String shiftType) {
  //   return List.from(pharmacists)..sort(
  //     (a, b) => (shiftCounts[a]![shiftType] ?? 0).compareTo(
  //       shiftCounts[b]![shiftType] ?? 0,
  //     ),
  //   );
  // }

  Future<Map<DateTime, Map<String, List<String>>>> generateSchedule() async {
    final schedule = <DateTime, Map<String, List<String>>>{};
    final numPharmacists = pharmacists.length;
    final numShifts = shiftTypes.length;

    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(year, month, day);
      final isWeekend =
          currentDate.weekday == DateTime.saturday ||
          currentDate.weekday == DateTime.sunday;
      final shiftAssignments = <String, List<String>>{
        for (var shift in shiftTypes) shift: [],
      };
      final assignedToday = <String>{};
      final currentDayShiftCounts = <String, int>{
        for (var shift in shiftTypes) shift: 0,
      };

      // Create a working list of available pharmacists, sorted primarily by their least worked shift this month
      final availablePharmacists = List<String>.from(pharmacists)..sort((a, b) {
        final minShiftsA = shiftTypes
            .map((type) => shiftCounts[a]![type] ?? 0)
            .reduce(min);
        final minShiftsB = shiftTypes
            .map((type) => shiftCounts[b]![type] ?? 0)
            .reduce(min);
        return minShiftsA.compareTo(minShiftsB);
      });

      // Determine the target number of pharmacists per shift for the current day
      final targetPerShift = (numPharmacists / numShifts).floor();
      final remainder = numPharmacists % numShifts;
      final dailyShiftTargets = <String, int>{};
      for (int i = 0; i < numShifts; i++) {
        dailyShiftTargets[shiftTypes[i]] =
            targetPerShift + (i < remainder ? 1 : 0);
      }

      // Iterate through the available pharmacists and assign them to shifts
      int pharmacistIndex = 0;
      while (assignedToday.length < numPharmacists &&
          pharmacistIndex < availablePharmacists.length * 2) {
        final pharmacist =
            availablePharmacists[pharmacistIndex % availablePharmacists.length];

        if (!assignedToday.contains(pharmacist)) {
          // Find the shifts that still need pharmacists today, sorted by their current assignment count
          final availableShiftsForDay =
              shiftTypes
                  .where(
                    (shift) =>
                        currentDayShiftCounts[shift]! <
                        dailyShiftTargets[shift]!,
                  )
                  .toList()
                ..sort(
                  (a, b) => currentDayShiftCounts[a]!.compareTo(
                    currentDayShiftCounts[b]!,
                  ),
                );

          if (availableShiftsForDay.isNotEmpty) {
            // Prioritize assigning to the shift that the current pharmacist has worked the least this month
            for (final shift in availableShiftsForDay) {
              if (shiftCounts[pharmacist]![shift] ==
                  shiftTypes
                      .map((type) => shiftCounts[pharmacist]![type] ?? 0)
                      .reduce(min)) {
                shiftAssignments[shift]!.add(pharmacist);
                assignedToday.add(pharmacist);
                currentDayShiftCounts[shift] =
                    (currentDayShiftCounts[shift] ?? 0) + 1;
                shiftCounts[pharmacist]![shift] =
                    (shiftCounts[pharmacist]![shift] ?? 0) + 1;
                shiftCounts[pharmacist]!['TotalShifts'] =
                    (shiftCounts[pharmacist]!['TotalShifts'] ?? 0) + 1;
                shiftCounts[pharmacist]!['DaysWorked'] =
                    (shiftCounts[pharmacist]!['DaysWorked'] ?? 0) + 1;
                if (isWeekend) {
                  shiftCounts[pharmacist]!['Weekend'] =
                      (shiftCounts[pharmacist]!['Weekend'] ?? 0) + 1;
                }
                break; // Move to the next pharmacist
              }
            }
            // If the least worked shift is full for the day, assign to other available shifts to maintain daily balance
            if (!assignedToday.contains(pharmacist) &&
                availableShiftsForDay.isNotEmpty) {
              final selectedShift = availableShiftsForDay.first;
              shiftAssignments[selectedShift]!.add(pharmacist);
              assignedToday.add(pharmacist);
              currentDayShiftCounts[selectedShift] =
                  (currentDayShiftCounts[selectedShift] ?? 0) + 1;
              shiftCounts[pharmacist]![selectedShift] =
                  (shiftCounts[pharmacist]![selectedShift] ?? 0) + 1;
              shiftCounts[pharmacist]!['TotalShifts'] =
                  (shiftCounts[pharmacist]!['TotalShifts'] ?? 0) + 1;
              shiftCounts[pharmacist]!['DaysWorked'] =
                  (shiftCounts[pharmacist]!['DaysWorked'] ?? 0) + 1;
              if (isWeekend) {
                shiftCounts[pharmacist]!['Weekend'] =
                    (shiftCounts[pharmacist]!['Weekend'] ?? 0) + 1;
              }
            }
          }
        }
        pharmacistIndex++;
      }

      schedule[currentDate] = shiftAssignments;
    }

    return schedule;
  }
}

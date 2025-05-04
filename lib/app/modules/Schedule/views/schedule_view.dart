import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/schedule_controller.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title:  Text("shiftSchedule".tr)),
      body: Obx(() {
        final schedule = controller.schedule;

        if (schedule.isEmpty) {
          return const Center(child: Text("No schedules available."));
        }

        // Ensure that selectedDay or focusedDay is non-null
        final selected = controller.selectedDay.value ?? controller.focusedDay.value;
        final normalizedSelected = DateTime(selected.year, selected.month, selected.day);
        final dailySchedule = schedule[normalizedSelected];

        return SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime(
                  controller.focusedDay.value.year,
                  controller.focusedDay.value.month - 3 <= 0
                      ? controller.focusedDay.value.month - 3 + 12
                      : controller.focusedDay.value.month - 3,
                  1,
                ),
                lastDay: DateTime(
                  controller.focusedDay.value.year,
                  controller.focusedDay.value.month + 3 > 12
                      ? controller.focusedDay.value.month + 3 - 12
                      : controller.focusedDay.value.month + 3,
                  1,
                ),
                focusedDay: controller.focusedDay.value,
                selectedDayPredicate: (day) => isSameDay(controller.selectedDay.value, day),
                eventLoader: (day) {
                  final daySchedule = schedule[DateTime(day.year, day.month, day.day)];
                  return daySchedule != null && daySchedule.shift.isNotEmpty ? [1] : [];
                },
                onDaySelected: (selectedDay, focusedDay) {
                  controller.selectedDay.value = selectedDay;
                  controller.focusedDay.value = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              if (dailySchedule != null && dailySchedule.shift.isNotEmpty)
                Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildReadableShiftList(dailySchedule.shift, theme),

                        // Text(
                        //   dailySchedule.shift,
                        //   style: theme.textTheme.bodyMedium,
                        // ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("No shifts assigned for this day."),
                ),
            ],
          ),
        );
      }),
    );
  }
}
List<Widget> _buildReadableShiftList(String shiftString, ThemeData theme) {
  final RegExp entryRegex = RegExp(r'(\w+): \[(.*?)\]');
  final matches = entryRegex.allMatches(shiftString);

  return matches.map((match) {
    final shiftType = match.group(1); // e.g. Morning
    final pharmacists = match.group(2); // e.g. Alice, Bob

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyMedium,
          children: [
            TextSpan(
              text: '$shiftType: ',
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: pharmacists?.split(',').map((e) => e.trim()).join(', '),
            ),
          ],
        ),
      ),
    );
  }).toList();
}


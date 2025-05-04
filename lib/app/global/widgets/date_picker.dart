import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatePickerField extends StatelessWidget {
  final Rx<DateTime> selectedDate;
  final String label;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() => TextFormField(
          readOnly: true,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate.value,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              selectedDate.value = picked;
            }
          },
          controller: TextEditingController(
            text: '${selectedDate.value.month}/${selectedDate.value.year}',
          ),
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate.value,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  selectedDate.value = picked;
                }
              },
            ),
          ),
        ));
  }
}

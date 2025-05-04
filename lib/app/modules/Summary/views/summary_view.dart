import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/summary_controller.dart';

class SummaryView extends GetView<SummaryController> {
  const SummaryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SummaryView'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => controller.generateAndSharePdf(controller.summary),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.summary.isEmpty) {
          return const Center(child: Text("No summary data available."));
        }
        return buildSummaryTable(controller.summary);
      }),
    );
  }

  Widget buildSummaryTable(Map<String, Map<String, int>> summary) {
  return SingleChildScrollView(
    child: Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Pharmacist')),
              DataColumn(label: Text('Total')),
              DataColumn(label: Text('Morning')),
              DataColumn(label: Text('Afternoon')),
              DataColumn(label: Text('Evening')),
              DataColumn(label: Text('Weekend')),
            ],
            rows: summary.entries.map((entry) {
              final p = entry.key;
              final data = entry.value;
              return DataRow(
                cells: [
                  DataCell(Text(p)),
                  DataCell(Text('${data['TotalShifts']}')),
                  DataCell(Text('${data['Morning']}')),
                  DataCell(Text('${data['Afternoon']}')),
                  DataCell(Text('${data['Evening']}')),
                  DataCell(Text('${data['Weekend']}')),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

}

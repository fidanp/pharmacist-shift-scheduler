import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../data/model/pharmacist_summary.dart';

class SummaryController extends GetxController {
  final RxMap<String, Map<String, int>> summary = <String, Map<String, int>>{}.obs;

void setSummary(Map<String, Map<String, int>> newSummary) {
  summary.value = newSummary;
}
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    loadSummaryFromHive();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  void loadSummaryFromHive() async {
  final box = await Hive.openBox<PharmacistSummary>('summaries');
  Map<String, Map<String, int>> loadedData = {};

  for (var key in box.keys) {
    final data = box.get(key);
    if (data != null) {
      // Assuming 'key' is the pharmacist's name (a String), and we map it to shift counts.
      loadedData[data.name] = {
        'Total': data.total,
        'Morning': data.morning,
        'Afternoon': data.afternoon,
        'Evening': data.evening,
        'Weekend': data.weekend,
      };
    }
  }

  summary.value = loadedData;  // Update the reactive variable
}


void generateAndSharePdf(Map<String, Map<String, int>> summary) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage( // Use MultiPage instead of Page
      build: (pw.Context context) => [
        pw.Text('Pharmacist Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.TableHelper.fromTextArray(
          headers: ['Pharmacist', 'Total', 'Morning', 'Afternoon', 'Evening', 'Weekend'],
          data: summary.entries.map((entry) {
            final data = entry.value;
            return [
              entry.key,
              '${data['TotalShifts']}',
              '${data['Morning']}',
              '${data['Afternoon']}',
              '${data['Evening']}',
              '${data['Weekend']}',
            ];
          }).toList(),
        ),
      ],
    ),
  );

  await Printing.sharePdf(bytes: await pdf.save(), filename: 'summary.pdf');
}

  }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacist/app/global/controllers/language_controller.dart';
import 'package:pharmacist/app/theme/theme_controller.dart';

import '../../../global/widgets/date_picker.dart';
import '../controllers/shift_scheduler_controller.dart';

class ShiftSchedulerView extends GetView<ShiftSchedulerScreenController> {
  const ShiftSchedulerView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Open a dialog or show a settings menu
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(
                        'settings'.tr,
                        style: theme.textTheme.headlineMedium!.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('selectLanguage'.tr),
                            onTap: () {
                              LanguageController languageController =
                                  Get.find<LanguageController>();
                              languageController.selectLanguage(
                                languageController.selectedLanguage.value ==
                                        'en'
                                    ? 'ar'
                                    : 'en',
                              );
                              Get.back();
                            },
                          ),
                          ListTile(
                            title: Text('changeTheme'.tr),
                            onTap: () {
                              ThemeController themeController =
                                  Get.find<ThemeController>();
                              themeController.toggleTheme();
                              Get.back();
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Close'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card with selected month and year
                Card(
                  color: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor: theme.primaryColorDark,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${'selectedMonth'.tr}: ${DateFormat.yMMMM().format(controller.selectedDate.value)}",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // Date Picker Button
                DatePickerField(
                  selectedDate: controller.selectedDate,
                  label: 'selectMonth'.tr,
                ),
                SizedBox(height: screenHeight * 0.03),

                // TextField for number of pharmacists
                TextField(
                  controller: controller.pharmacistNameController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 2,
                      ),
                    ),
                    labelText: 'enterPharmacistNames'.tr,
                    hintText: 'Each name on a new line',
                    prefixIcon: Icon(Icons.person, color: theme.primaryColor),
                    suffixIcon:
                        controller.pharmacistNameController.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: theme.primaryColor,
                              ),
                              onPressed:
                                  () =>
                                      controller.pharmacistNameController
                                          .clear(),
                            )
                            : null,
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Text "or"
                Center(child: Text("or".tr, style: theme.textTheme.bodyMedium)),

                SizedBox(height: screenHeight * 0.03),

                // Import from Excel Button
                _buildTextButton(
                  label: 'importFromExcel'.tr,
                  icon: Icons.upload_file,
                  onPressed: controller.importNamesFromExcel,
                  context: context,
                ),

                // Schedule Button at the bottom
                SizedBox(
                  height: screenHeight * 0.1,
                ), // Add space before the Schedule button
                Center(
                  child: _buildTextButton(
                    label: 'schedule'.tr,
                    icon: Icons.schedule,
                    onPressed: () {
                      // Your schedule functionality here
                      controller.generateShiftSchedule();
                      // Get.snackbar("scheduled".tr, "Your schedule has been set.");
                    },
                    context: context,
                    isPrimary:
                        true, // Use primary color for the schedule button
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom method to build text buttons
  Widget _buildTextButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required BuildContext context,
    bool isPrimary = false,
  }) {
    final theme = Theme.of(context);
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: isPrimary ? theme.colorScheme.onPrimary : theme.primaryColor,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isPrimary ? theme.colorScheme.onPrimary : theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: isPrimary ? theme.primaryColor : Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.primaryColor, width: 2),
        ),
      ),
    );
  }
}

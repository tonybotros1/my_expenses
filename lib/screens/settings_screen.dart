import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../consts.dart';
import '../controllers/settings_controller.dart';
import '../widgets/custom_field.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  SettingsController get _settingsController =>
      Get.isRegistered<SettingsController>()
      ? Get.find<SettingsController>()
      : Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: textFontForAppBar)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.r),
          child: Obx(
            () => Column(
              spacing: 24.h,
              children: [
                detailsLine(
                  context: context,
                  icon: Icons.person,
                  title: 'Name',
                  value: _settingsController.userName.value,
                  onEdit: () => _showEditDialog(
                    context: context,
                    title: 'Name',
                    initialValue: _settingsController.userName.value,
                    onSave: _settingsController.updateUserName,
                  ),
                ),
                detailsLine(
                  context: context,
                  icon: Icons.attach_money,
                  title: 'Currency',
                  value: _settingsController.currency.value,
                  onEdit: () => _showEditDialog(
                    context: context,
                    title: 'Currency',
                    initialValue: _settingsController.currency.value,
                    onSave: _settingsController.updateCurrency,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Row(
                    spacing: 16.w,
                    children: [
                      Icon(
                        Icons.dark_mode_outlined,
                        color: colorScheme.onSurfaceVariant,
                        size: 30.sp,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                              text: 'Dark Theme',
                              color: colorScheme.onSurface,
                              isBold: true,
                              fontSize: 18,
                              maxWidth: null,
                            ),
                            customText(
                              text: _settingsController.isDarkMode.value
                                  ? 'Enabled'
                                  : 'Disabled',
                              color: colorScheme.onSurfaceVariant,
                              isBold: true,
                              fontSize: 14,
                              maxWidth: null,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _settingsController.isDarkMode.value,
                        activeThumbColor: mainColor,
                        onChanged: _settingsController.setDarkMode,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailsLine({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onEdit,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        spacing: 16.w,
        children: [
          Icon(icon, color: colorScheme.onSurfaceVariant, size: 30.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: title,
                  color: colorScheme.onSurface,
                  isBold: true,
                  fontSize: 18,
                  maxWidth: null,
                ),
                customText(
                  text: value,
                  color: colorScheme.onSurfaceVariant,
                  isBold: true,
                  fontSize: 14,
                  maxWidth: null,
                ),
              ],
            ),
          ),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
        ],
      ),
    );
  }

  Future<void> _showEditDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Future<void> Function(String value) onSave,
  }) {
    final controller = TextEditingController(text: initialValue);

    return Get.dialog(
      Dialog(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              customLabeledTextField(
                label: title,
                controller: controller,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 18.h),
              ElevatedButton(
                onPressed: () async {
                  await onSave(controller.text);
                  Get.back();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/controllers/daily_tools_controller.dart';
import 'package:my_expenses/controllers/main_screen_controller.dart';
import 'package:my_expenses/controllers/settings_controller.dart';
import '../consts.dart';
import '../widgets/filtering_drop_down_menu.dart';
import '../widgets/filtering_text_field.dart';
import '../widgets/custom_field.dart';
import '../widgets/pie_chart.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final MainScreenController _mainScreenController = Get.put(
    MainScreenController(),
  );
  final SettingsController _settingsController =
      Get.isRegistered<SettingsController>()
      ? Get.find<SettingsController>()
      : Get.put(SettingsController());
  final DailyToolsController _toolsController =
      Get.isRegistered<DailyToolsController>()
      ? Get.find<DailyToolsController>()
      : Get.put(DailyToolsController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            'Hi, ${_settingsController.userName.value.split(' ').first}',
            style: textFontForAppBar,
          ),
        ),
      ),
      drawer: Drawer(
        width: (Get.width * 0.75).w,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: mainColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: colorScheme.surface,
                    child: Obx(
                      () => Text(
                        _settingsController.userName.value.isEmpty
                            ? '?'
                            : _settingsController.userName.value[0]
                                  .toUpperCase(),
                        style: TextStyle(fontSize: 24.sp, color: mainColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Obx(
                    () => Text(
                      _settingsController.userName.value,
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, size: 24.sp),
              title: Text('Home', style: regTextStyle),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.category_outlined, size: 24.sp),
              title: Text('My Categories', style: regTextStyle),
              onTap: () {
                Get.back();
                Get.toNamed('/myCategories');
              },
            ),
            ListTile(
              leading: Icon(Icons.auto_awesome_motion, size: 24.sp),
              title: Text('Daily Tools', style: regTextStyle),
              onTap: () {
                Get.back();
                Get.toNamed('/dailyTools');
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.settings, size: 24.sp),
              title: Text('Settings', style: regTextStyle),
              onTap: () {
                Get.back();
                Get.toNamed('/settings');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: DateFilterDropdown(
                            selectedFilter:
                                _mainScreenController.selectedFilter.value,
                            onChanged: (filter) {
                              _mainScreenController.dateController.value
                                  .clear();
                              _mainScreenController.setFilter(filter!);
                            },
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: CustomFilterField(
                            controller:
                                _mainScreenController.dateController.value,
                            hintText: 'Date',
                            suffixIcon: IconButton(
                              iconSize: 20.sp,
                              color: colorScheme.onSurfaceVariant,
                              onPressed: () {
                                selectDateContext(
                                  context,
                                  _mainScreenController.dateController.value,
                                );
                              },
                              icon: Icon(Icons.date_range_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h),
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(24.r),
                        width: constraints.maxWidth,
                        constraints: BoxConstraints(minHeight: 170.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          color: mainColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            customText(
                              text: 'Safe to Spend',
                              fontSize: 20.sp,
                              isBold: true,
                            ),
                            SizedBox(height: 24.h),
                            Obx(
                              () => FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                      text: _settingsController.currency.value,
                                      fontSize: 16.sp,
                                      maxWidth: null,
                                    ),
                                    customText(
                                      text: _toolsController.safeToSpend
                                          .toString(),
                                      fontSize: 42.sp,
                                      maxWidth: null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 28.w,
                        top: 28.h,
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white.withValues(alpha: 0.34),
                          size: 58.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                _summaryStrip(context),
                _quickActions(context),
                _templatesAndRecent(context),
                Obx(() {
                  return SizedBox(
                    height: 400.h,
                    child: ExpensePieChart(
                      data: _mainScreenController.getChartData(
                        _mainScreenController.items,
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _summaryStrip(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Obx(
      () => Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
        child: Row(
          children: [
            Expanded(
              child: _summaryTile(
                context,
                label: 'Today',
                value: _money(_toolsController.todayTotal),
                icon: Icons.today_outlined,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _summaryTile(
                context,
                label: 'Week',
                value: _money(_toolsController.weekTotal),
                icon: Icons.view_week_outlined,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _summaryTile(
                context,
                label: 'Top',
                value: _toolsController.topCategoryThisMonth,
                icon: Icons.trending_up,
                valueColor: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryTile(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.onSurfaceVariant, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: valueColor ?? mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showQuickAdd(context),
              icon: const Icon(Icons.flash_on),
              label: const Text('Quick Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          IconButton.filledTonal(
            onPressed: () => Get.toNamed('/dailyTools'),
            color: colorScheme.onSecondaryContainer,
            icon: const Icon(Icons.auto_awesome_motion),
            tooltip: 'Daily Tools',
          ),
        ],
      ),
    );
  }

  Widget _templatesAndRecent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Obx(() {
      final templates = _toolsController.favoriteTemplates.take(4).toList();
      final recentItems = _toolsController.recentUniqueItems.take(4).toList();

      if (templates.isEmpty && recentItems.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.only(top: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (templates.isNotEmpty) ...[
              _railTitle(context, 'Favorites'),
              SizedBox(
                height: 78.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    final template = templates[index];
                    return _quickCard(
                      context,
                      title: template.name,
                      subtitle: _money(template.totalPrice),
                      icon: _toolsController.categoryIcon(
                        _toolsController.getCategoryById(template.category),
                      ),
                      onTap: () =>
                          _toolsController.addExpenseFromTemplate(template),
                    );
                  },
                  separatorBuilder: (_, _) => SizedBox(width: 10.w),
                  itemCount: templates.length,
                ),
              ),
            ],
            if (recentItems.isNotEmpty) ...[
              SizedBox(height: 14.h),
              _railTitle(context, 'Recent'),
              SizedBox(
                height: 78.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    final item = recentItems[index];
                    final category = _toolsController.getCategoryById(
                      item.category,
                    );
                    return _quickCard(
                      context,
                      title: item.name,
                      subtitle: _money(item.price),
                      icon: _toolsController.categoryIcon(category),
                      onTap: () => _toolsController.addExpenseFromRecent(item),
                      onLongPress: () =>
                          _toolsController.createTemplateFromItem(item),
                    );
                  },
                  separatorBuilder: (_, _) => SizedBox(width: 10.w),
                  itemCount: recentItems.length,
                ),
              ),
            ],
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Long press a recent item to favorite it.',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _railTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _quickCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 168.w,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.onSurfaceVariant),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showQuickAdd(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(
          16.w,
          16.h,
          16.w,
          16.h + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Add',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        controller: _toolsController.quickPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixIcon: Icon(Icons.payments_outlined),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: customLabeledTextField(
                        label: 'Qty',
                        controller: _toolsController.quickQuantityController,
                        keyboardType: TextInputType.number,
                        isnumber: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                  initialValue: _toolsController.quickCategoryId.value,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _toolsController.categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      _toolsController.quickCategoryId.value = value,
                ),
                if (_toolsController.wallets.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<String>(
                    initialValue: _toolsController.quickWalletId.value,
                    decoration: const InputDecoration(labelText: 'Wallet'),
                    items: _toolsController.wallets
                        .map(
                          (wallet) => DropdownMenuItem(
                            value: wallet.id,
                            child: Text(wallet.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        _toolsController.quickWalletId.value = value,
                  ),
                ],
                SizedBox(height: 8.h),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: const Text('Optional details'),
                  children: [
                    customLabeledTextField(
                      label: 'Name',
                      controller: _toolsController.quickNameController,
                      isRequired: false,
                    ),
                    SizedBox(height: 12.h),
                    customLabeledTextField(
                      label: 'Note',
                      controller: _toolsController.quickNoteController,
                      isRequired: false,
                    ),
                  ],
                ),
                CheckboxListTile(
                  value: _toolsController.quickSaveAsTemplate.value,
                  onChanged: (value) =>
                      _toolsController.quickSaveAsTemplate.value =
                          value ?? false,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Save as favorite'),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await _toolsController.addQuickExpense();
                      if (Get.isBottomSheetOpen == true) Get.back();
                    },
                    icon: const Icon(Icons.done),
                    label: const Text('Add Expense'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  String _money(double value) {
    return '${_settingsController.currency.value} ${NumberFormat('#,##0.00').format(value)}';
  }
}

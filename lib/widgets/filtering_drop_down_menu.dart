import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../consts.dart';
import '../controllers/main_screen_controller.dart';

class DateFilterDropdown extends StatelessWidget {
  final DateFilterType selectedFilter;
  final ValueChanged<DateFilterType?> onChanged;

  const DateFilterDropdown({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const Map<DateFilterType, String> dateFilterLabels = {
      DateFilterType.all: 'All',
      DateFilterType.today: 'Today',
      DateFilterType.thisWeek: 'This Week',
      DateFilterType.thisMonth: 'This Month',
      DateFilterType.thisYear: 'This Year',
      DateFilterType.custom: 'Custom',
    };

    return Container(
      height: textFieldHeight,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<DateFilterType>(
          value: selectedFilter,
          isExpanded: true,

          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          onChanged: onChanged,
          items: DateFilterType.values.map((filter) {
            return DropdownMenuItem<DateFilterType>(
              value: filter,
              child: Text(dateFilterLabels[filter]!),
            );
          }).toList(),
        ),
      ),
    );
  }
}

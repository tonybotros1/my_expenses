import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../consts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Settings', style: textFontForAppBar),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(25.r),
          child: Column(
            spacing: 30,
            children: [
              detailsLine(icon: Icons.person, title: 'Name', value: 'Tony B'),
              detailsLine(
                icon: Icons.attach_money,
                title: 'Currency',
                value: 'SYP',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row detailsLine({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      spacing: 20,
      children: [
        Icon(icon, color: Colors.grey.shade700, size: 35),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              text: title,
              color: Colors.blueGrey,
              isBold: true,
              fontSize: 18,
            ),
            customText(
              text: value,
              color: Colors.grey.shade700,
              isBold: true,
              fontSize: 15,
            ),
          ],
        ),
      ],
    );
  }
}

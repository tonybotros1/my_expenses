import 'package:flutter/material.dart';

import '../consts.dart';

class AllItems extends StatelessWidget {
  const AllItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('My Item', style: textFontForAppBar),
      ),
    );
  }
}

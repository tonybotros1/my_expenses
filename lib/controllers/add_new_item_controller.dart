import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNewItemController extends GetxController {
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String? selectedCategory;
  List categories = [
    'Food','Transportations','Clothes','Bills','Entertainment','Devices'
  ];
}

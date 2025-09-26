import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryController extends GetxController {
  // RxList to store categories
  var categories = <Data>[].obs;

  // Controller for the text field
  TextEditingController categoryController = TextEditingController();

  // Dummy userId for new category (replace with actual userId)
  String userId = "user123";

  // Fetch categories from the API
  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse(
        'https://starrd-app.vercel.app/api/v1/categories/get-categories',
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final categoryData = GetCategory.fromJson(jsonData);
      categories.assignAll(categoryData.data!); // Update the categories list
    } else {
      print("Failed to load categories");
    }
  }

  // Function to add a new category
  void addCategory() {
    if (categoryController.text.isNotEmpty) {
      categories.add(
        Data(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          categoryName: categoryController.text,
          userId: userId,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
      );
    }
  }
}

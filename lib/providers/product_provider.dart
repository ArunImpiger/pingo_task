import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pingo_task/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['products'] as List;
      _products = data.map((productJson) => Product.fromJson(productJson)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load products');
    }
  }
}

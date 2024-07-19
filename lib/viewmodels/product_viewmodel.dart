import 'package:flutter/material.dart';
import 'package:pingo_task/models/product_model.dart';
import '../providers/product_provider.dart';

class ProductViewModel with ChangeNotifier {
  final ProductProvider _productProvider;

  ProductViewModel(this._productProvider);

  List<Product> get products => _productProvider.products;

  Future<void> fetchProducts() async {
    await _productProvider.fetchProducts();

    notifyListeners();
  }
}

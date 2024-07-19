import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:pingo_task/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _isLoading = true;
  bool isEnableDiscount = false;
  double discountedPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchRemoteConfig();
  }

  Future<void> _fetchProducts() async {
    try {
      await Provider.of<ProductViewModel>(context, listen: false).fetchProducts();
    } catch (error) {
      print('Error fetching products: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchRemoteConfig() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 0),
        ),
      );

      await remoteConfig.fetchAndActivate();
      setState(() {
        isEnableDiscount = remoteConfig.getBool('isEnableDiscount');
        print('Remote config updated, isEnableDiscount: $isEnableDiscount');
      });
    } catch (e) {
      print('Error fetching remote config: $e');
    }
  }

  String getDiscountedPrice(double price,double percent){
    double result = (percent / 100) * price;
    return result.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C54BE),
        title: const Text(
          "e-shop",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,color: Colors.white,),
            onPressed: () async {
              await authProvider.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: productViewModel.products.length,
        itemBuilder: (ctx, i) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  productViewModel.products[i].thumbnail,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                productViewModel.products[i].title,
                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
              ),
              Expanded(
                child: Text(productViewModel.products[i].description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14
                  ),
                ),
              ),
              Row(
                children: [
                  (isEnableDiscount == true) ? Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: " \$ ${productViewModel.products[i].price.toString()} ",
                          style: TextStyle(
                            color: const Color(0XFFCED3DC),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: (isEnableDiscount == true) ? TextDecoration.lineThrough : TextDecoration.none,
                            decorationColor: const Color(0XFFCED3DC),
                          ),
                        ),
                      ],
                    ),
                  ) : Container(),
                  const SizedBox(width: 5),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: '\$',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: (isEnableDiscount == true) ? getDiscountedPrice(productViewModel.products[i].price, productViewModel.products[i].discountPercentage) : "${productViewModel.products[i].price}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  (isEnableDiscount == true) ? Expanded(
                    child: Text(
                      "${productViewModel.products[i].discountPercentage}% off",
                      style: const TextStyle(color: Color(0xFF5EFB5B),fontSize: 10,fontWeight: FontWeight.w500,),
                    ),
                  ) : Container(),
                ],
              ),
            ],
          ),
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .6,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
      ),
    );
  }
}


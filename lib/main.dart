import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:pingo_task/view/login_page.dart';
import 'package:pingo_task/view/product_page.dart';
import 'package:pingo_task/view/signup_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'viewmodels/product_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.fetchAndActivate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProxyProvider<ProductProvider, ProductViewModel>(
          create: (ctx) => ProductViewModel(Provider.of<ProductProvider>(ctx, listen: false)),
          update: (ctx, productProvider, previousProductViewModel) => ProductViewModel(productProvider),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-commerce App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0C54BE)),
              fontFamily: 'Poppins'
            ),
            home: authProvider.isAuthenticated ? const ProductPage() : const LoginPage(),
            routes: {
              '/login': (ctx) => const LoginPage(),
              '/signup': (ctx) => const SignupPage(),
              '/product': (ctx) => const ProductPage(),
            },
          );
        },
      ),
    );
  }
}

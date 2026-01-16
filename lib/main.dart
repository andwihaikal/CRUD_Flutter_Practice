import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/hive_service.dart';
import 'screens/home_screen.dart';
import 'models/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 Starting Flutter Web App...');

  try {
    await Hive.initFlutter();

    try {
      Hive.registerAdapter(ProductAdapter());
      print('✅ ProductAdapter registered');
    } catch (e) {
      print('⚠️ Cannot register adapter, using fallback: $e');
    }

    await HiveService.init();

    runApp(const MyApp());
  } catch (e) {
    print('❌ App initialization error: $e');

    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Manager',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color.fromRGBO(248, 249, 250, 1),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

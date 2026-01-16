import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';

class HiveService {
  static late Box<Product> _productsBox;
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();

      try {
        if (!Hive.isAdapterRegistered(0)) {
          Hive.registerAdapter(ProductAdapter());
        }
      } catch (e) {
        print('⚠️ Adapter registration warning: $e');
      }

      _productsBox = await Hive.openBox<Product>('products_v1');
      _isInitialized = true;
      print('✅ HiveService initialized successfully');
    } catch (e) {
      print('❌ Hive initialization failed: $e');

      await _initWebFallback();
    }
  }

  static Future<void> _initWebFallback() async {
    print('🔄 Trying web fallback...');
    try {
      _productsBox = await Hive.openBox<Product>('products_memory');
      _isInitialized = true;
      print('✅ Web fallback initialized');
    } catch (e) {
      print('❌ Web fallback also failed: $e');
      throw e;
    }
  }

  static bool get isInitialized => _isInitialized;

  static void _checkInitialized() {
    if (!_isInitialized) {
      throw Exception('HiveService not initialized. Please restart app.');
    }
  }

  // CRUD Operations
  static Future<void> addProduct(Product product) async {
    _checkInitialized();
    await _productsBox.put(product.id, product);
  }

  static Future<void> updateProduct(Product product) async {
    _checkInitialized();
    await _productsBox.put(product.id, product);
  }

  static Future<void> deleteProduct(String id) async {
    _checkInitialized();
    await _productsBox.delete(id);
  }

  static Product? getProduct(String id) {
    _checkInitialized();
    return _productsBox.get(id);
  }

  static List<Product> getAllProducts() {
    _checkInitialized();
    return _productsBox.values.toList();
  }

  static Stream<List<Product>> watchProducts() {
    _checkInitialized();
    return _productsBox.watch().map((event) => getAllProducts());
  }

  static Future<void> clearAll() async {
    _checkInitialized();
    await _productsBox.clear();
  }

  static int get productCount {
    _checkInitialized();
    return _productsBox.length;
  }
}

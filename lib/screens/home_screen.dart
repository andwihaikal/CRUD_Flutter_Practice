import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/hive_service.dart';
import '../models/product.dart';
import 'add_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Coba inisialisasi ulang jika belum
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!HiveService.isInitialized) {
        try {
          await HiveService.init();
          setState(() {});
        } catch (e) {
          print('Failed to initialize Hive: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Manager'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (!HiveService.isInitialized)
            IconButton(
              icon: const Icon(Icons.warning, color: Colors.orange),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mode offline - data disimpan sementara'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
            ),
        ],
      ),
      body: HiveService.isInitialized
          ? ValueListenableBuilder(
              valueListenable: Hive.box<Product>('products_v1').listenable(),
              builder: (context, Box<Product> box, _) {
                final products = box.values.toList();

                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 100,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Belum ada produk',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Tambahkan produk pertama Anda!',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddProductScreen(),
                              ),
                            );
                          },
                          child: const Text('Tambah Produk Pertama'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(
                            Icons.shopping_bag,
                            color: Colors.blue,
                          ),
                        ),
                        title: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.description),
                            const SizedBox(height: 4),
                            Text(
                              'Rp ${product.price.toStringAsFixed(2)} • ${product.quantity} pcs',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Kategori: ${product.category}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // TODO: Implement edit
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await HiveService.deleteProduct(product.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Produk "${product.name}" dihapus',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Menginisialisasi database...'),
                  SizedBox(height: 10),
                  Text(
                    'Jika ini terlalu lama, coba refresh halaman',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (HiveService.isInitialized) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddProductScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tunggu inisialisasi database selesai...'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../services/hive_service.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product}); // Use super.key

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late String _selectedCategory;

  final List<String> _categories = [
    'Elektronik',
    'Fashion',
    'Makanan',
    'Minuman',
    'Olahraga',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _quantityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );
    _selectedCategory = widget.product.category;
  }

  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = Product(
        id: widget.product.id,
        name: _nameController.text,
        description: _descController.text,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        category: _selectedCategory,
        createdAt: widget.product.createdAt,
        updatedAt: DateTime.now(),
      );

      HiveService.updateProduct(updatedProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Produk "${updatedProduct.name}" berhasil diperbarui!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Produk',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form Field: Nama Produk
              Text(
                'Nama Produk',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(
                    25,
                    118,
                    210,
                    1,
                  ), // Colors.blue.shade800 equivalent
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25), // Fix for withOpacity
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama produk',
                    hintStyle: GoogleFonts.poppins(),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    prefixIcon: const Icon(
                      Icons.shopping_bag,
                      color: Colors.blue,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Form Field: Kategori
              Text(
                'Kategori',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(
                    25,
                    118,
                    210,
                    1,
                  ), // Colors.blue.shade800 equivalent
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25), // Fix for withOpacity
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  initialValue:
                      _selectedCategory, // Use initialValue instead of value
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category, style: GoogleFonts.poppins()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    prefixIcon: const Icon(Icons.category, color: Colors.blue),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Form Field: Deskripsi
              Text(
                'Deskripsi',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(
                    25,
                    118,
                    210,
                    1,
                  ), // Colors.blue.shade800 equivalent
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25), // Fix for withOpacity
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Masukkan deskripsi produk',
                    hintStyle: GoogleFonts.poppins(),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    prefixIcon: const Icon(
                      Icons.description,
                      color: Colors.blue,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Row untuk Harga dan Kuantitas
              Row(
                children: [
                  // Harga
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Harga',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(
                              25,
                              118,
                              210,
                              1,
                            ), // Colors.blue.shade800 equivalent
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(
                                  25,
                                ), // Fix for withOpacity
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: GoogleFonts.poppins(),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              prefixIcon: const Icon(
                                Icons.attach_money,
                                color: Colors.blue,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harga tidak boleh kosong';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Masukkan angka yang valid';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Kuantitas
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kuantitas',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(
                              25,
                              118,
                              210,
                              1,
                            ), // Colors.blue.shade800 equivalent
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(
                                  25,
                                ), // Fix for withOpacity
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: GoogleFonts.poppins(),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              prefixIcon: const Icon(
                                Icons.inventory,
                                color: Colors.blue,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kuantitas tidak boleh kosong';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Masukkan angka yang valid';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Tombol Update
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _updateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.update, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        'Update Produk',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

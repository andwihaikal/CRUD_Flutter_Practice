import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const ProductCard({
    super.key, // Use super.key
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.purple.shade50],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40), // Fix for withOpacity
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getCategoryColor(product.category),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Text(
                  product.category,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepPurple,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: product.quantity > 10
                              ? const Color.fromARGB(255, 220, 237, 200)
                              : product.quantity > 0
                              ? const Color.fromARGB(255, 255, 236, 179)
                              : const Color.fromARGB(255, 255, 205, 210),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${product.quantity} pcs',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: product.quantity > 10
                                ? const Color.fromARGB(255, 56, 142, 60)
                                : product.quantity > 0
                                ? const Color.fromARGB(255, 245, 124, 0)
                                : const Color.fromARGB(255, 211, 47, 47),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color.fromRGBO(
                        97,
                        97,
                        97,
                        1,
                      ), // Fix for withOpacity
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currencyFormat.format(product.price),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color.fromRGBO(
                            25,
                            118,
                            210,
                            1,
                          ), // Colors.blue.shade800 equivalent
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: onEdit,
                            icon: Icon(Icons.edit, color: Colors.blue.shade600),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            onPressed: onDelete,
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade600,
                            ),
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Diperbarui: ${DateFormat('dd MMM yyyy HH:mm').format(product.updatedAt)}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color.fromRGBO(
                        158,
                        158,
                        158,
                        1,
                      ), // Colors.grey.shade500 equivalent
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'elektronik':
        return Colors.blue;
      case 'fashion':
        return Colors.pink;
      case 'makanan':
        return Colors.orange;
      case 'minuman':
        return Colors.green;
      case 'olahraga':
        return Colors.red;
      default:
        return Colors.purple;
    }
  }
}

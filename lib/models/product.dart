import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  double price;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  String category;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime updatedAt;

  Product({
    String? id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      category: map['category'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  // Convert ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Copy with method
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
    String? category,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

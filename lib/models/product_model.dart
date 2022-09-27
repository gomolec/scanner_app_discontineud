import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'product_model.g.dart';

@HiveType(typeId: 2)
class Product extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String code;
  @HiveField(3)
  final int actualStock;
  @HiveField(4)
  final int previousStock;
  @HiveField(5)
  final bool isPinned;

  const Product({
    this.id = 0,
    required this.name,
    required this.code,
    this.actualStock = 0,
    required this.previousStock,
    this.isPinned = false,
  });

  Product copyWith({
    int? id,
    String? name,
    String? code,
    int? actualStock,
    int? previousStock,
    bool? isPinned,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      actualStock: actualStock ?? this.actualStock,
      previousStock: previousStock ?? this.previousStock,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'actualStock': actualStock,
      'previousStock': previousStock,
      'isPinned': isPinned,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      actualStock: map['actualStock']?.toInt() ?? 0,
      previousStock: map['previousStock']?.toInt() ?? 0,
      isPinned: map['isPinned'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, name: $name, code: $code, actualStock: $actualStock, previousStock: $previousStock, isPinned: $isPinned)';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      code,
      actualStock,
      previousStock,
      isPinned,
    ];
  }
}

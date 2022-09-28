import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:scanner_app/models/models.dart';

part 'history_action_model.g.dart';

@HiveType(typeId: 3)
class HistoryAction extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final Product? oldProduct;
  @HiveField(2)
  final Product? updatedProduct;
  @HiveField(3)
  final bool isRedo;

  const HistoryAction({
    required this.id,
    this.oldProduct,
    this.updatedProduct,
    this.isRedo = false,
  });

  HistoryAction copyWith({
    int? id,
    Product? oldProduct,
    Product? updatedProduct,
    bool? isRedo,
  }) {
    return HistoryAction(
      id: id ?? this.id,
      oldProduct: oldProduct ?? this.oldProduct,
      updatedProduct: updatedProduct ?? this.updatedProduct,
      isRedo: isRedo ?? this.isRedo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'oldProduct': oldProduct?.toMap(),
      'updatedProduct': updatedProduct?.toMap(),
      'isRedo': isRedo,
    };
  }

  factory HistoryAction.fromMap(Map<String, dynamic> map) {
    return HistoryAction(
      id: map['id']?.toInt() ?? 0,
      oldProduct:
          map['oldProduct'] != null ? Product.fromMap(map['oldProduct']) : null,
      updatedProduct: map['updatedProduct'] != null
          ? Product.fromMap(map['updatedProduct'])
          : null,
      isRedo: map['isRedo'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryAction.fromJson(String source) =>
      HistoryAction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HistoryAction(id: $id, oldProduct: $oldProduct, updatedProduct: $updatedProduct, isRedo: $isRedo)';
  }

  @override
  List<Object?> get props => [id, oldProduct, updatedProduct, isRedo];
}

import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../models/models.dart';

class ProductsRepository {
  final HiveInterface hiveInterface;
  final _controller = BehaviorSubject<List<Product>>();

  ProductsRepository({
    required this.hiveInterface,
  });

  Box<Product>? _productsBox;
  List<Product> _products = [];

  Stream<List<Product>> get products => _controller.stream;
  bool get isSessionOpened => _productsBox != null;

  void addToStream(List<Product> products) => _controller.sink.add(products);

  Future<void> openProductsSession(String id) async {
    if (_productsBox != null) {
      await closeProductsSession();
    }
    _productsBox = await hiveInterface.openBox("products-$id");
    _products = _productsBox!.values.toList();
    addToStream(_products);
  }

  Future<void> closeProductsSession() async {
    if (_productsBox != null) {
      await _productsBox!.close();
      _productsBox = null;
    }
    _products = [];
    addToStream(_products);
  }

  Future<void> deleteProductsSession(String id) async {
    if (_productsBox != null && _productsBox!.name == "products-$id") {
      await closeProductsSession();
    }
    hiveInterface.deleteBoxFromDisk("products-$id");
  }

  Product? findById(int id) {
    return _products
        .cast<Product?>()
        .firstWhere((product) => product!.id == id, orElse: () => null);
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((it) => it.id == product.id);
    if (index != -1) {
      _products[index] = product;
      addToStream(_products);
      _productsBox!.put(product.id, product);
    }
  }

  Product addProduct(Product product) {
    int id;
    if (_products.isNotEmpty) {
      id = _products.last.id + 1;
    } else {
      id = 0;
    }
    Product newProduct = product.copyWith(id: id);
    _products.add(newProduct);
    _productsBox!.put(id, newProduct);
    addToStream(_products);
    return newProduct;
  }

  void deleteProduct(int id) {
    final index = _products.indexWhere((it) => it.id == id);
    if (index != -1) {
      _products.removeAt(index);
      addToStream(_products);
      _productsBox!.delete(id);
    }
  }
}

import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/models.dart';

class ProductsRepository {
  final HiveInterface hiveInterface;
  final _controller = StreamController<List<Product>>.broadcast();

  ProductsRepository({
    required this.hiveInterface,
  });

  Box<Product>? _productsBox;
  List<Product> _products = [];

  Stream<List<Product>> get products => _controller.stream;

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
      _productsBox!.close();
      _productsBox = null;
    }
    _products = [];
    addToStream(_products);
  }

  void deleteProductsSession(String id) async {
    if (_productsBox != null && _productsBox!.name == "products-$id") {
      await closeProductsSession();
    }
    final Box<Product> boxToDelete =
        await hiveInterface.openBox("products-$id");
    await boxToDelete.deleteFromDisk();
  }

  Session? findById(String id) {
    return _products
        .cast<Session?>()
        .firstWhere((session) => session!.id == id, orElse: () => null);
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((it) => it.id == product.id);
    if (index != -1) {
      _products[index] = product;
      addToStream(_products);
      _productsBox!.put(product.id, product);
    }
  }

  void addProduct(Product product) {
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

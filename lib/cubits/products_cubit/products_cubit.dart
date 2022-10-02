import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../repositories/history_repository.dart';
import '../../repositories/products_repository.dart';
import 'services/products_querier.dart';
import 'services/products_sorter.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository productsRepository;
  final HistoryRepository historyRepository;
  final ProductsSorter _sorter = ProductsSorter();
  final ProductsQuerier _querier = ProductsQuerier();
  late final StreamSubscription _subscription;

  ProductsCubit({
    required this.productsRepository,
    required this.historyRepository,
  }) : super(ProductsInitial()) {
    _subscribe();
  }

  List<Product> products = [];
  String searchQuery = "";

  void _subscribe() {
    _subscription = productsRepository.products.listen(
      (items) {
        products = items.toList();
        emitProducts();
      },
      //TODO onError: (error) => emit(ListError('$error')),
    );
  }

  void emitProducts() {
    List<Product> newProducts = _sorter.sortByPinned(
      _querier.query(products, searchQuery),
    );
    emit(ProductsLoaded(products: newProducts));
  }

  void updateProduct(Product updatedProduct) {
    // historyRepository.addActivity(
    //     productsRepository.findById(updatedProduct.id), updatedProduct);
    productsRepository.updateProduct(updatedProduct);
  }

  void getQueriedProductList(String query) {
    searchQuery = query;
    emitProducts();
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}

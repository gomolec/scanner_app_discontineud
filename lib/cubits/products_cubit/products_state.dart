part of 'products_cubit.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> scannedProducts;
  final List<Product> unscannedProducts;

  const ProductsLoaded({
    required this.scannedProducts,
    required this.unscannedProducts,
  });

  @override
  List<Object> get props => [scannedProducts, unscannedProducts];
}

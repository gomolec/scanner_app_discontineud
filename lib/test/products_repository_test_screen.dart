import 'dart:math';

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../repositories/products_repository.dart';

class ProductsRepositoryTestScreen extends StatelessWidget {
  final ProductsRepository productsRepository;
  const ProductsRepositoryTestScreen({
    Key? key,
    required this.productsRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products Repository Test")),
      body: Column(
        children: [
          StreamBuilder(
            stream: productsRepository.products,
            builder:
                (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Product product = snapshot.data![index];
                    return ListTile(
                      leading: Text("${product.id + 1}."),
                      title: Text(product.name),
                      subtitle: Text(
                          "${product.code} - ${product.actualStock}/${product.previousStock}"),
                      onTap: () {
                        productsRepository.updateProduct(
                          product.copyWith(
                              actualStock: product.actualStock +
                                  Random().nextInt(10) +
                                  1),
                        );
                      },
                      onLongPress: () {
                        productsRepository.deleteProduct(product.id);
                      },
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              productsRepository.addProduct(
                Product(
                  name: "Produkt testowy nr ${Random().nextInt(100) + 1}",
                  code: "TEST TEST TEST TEST TEST",
                  previousStock: Random().nextInt(15) + 5,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

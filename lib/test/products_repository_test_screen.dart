import 'dart:math';

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../repositories/history_repository.dart';
import '../repositories/products_repository.dart';
import 'history_repository_test_screen.dart';

class ProductsRepositoryTestScreen extends StatelessWidget {
  final ProductsRepository productsRepository;
  final HistoryRepository historyRepository;

  const ProductsRepositoryTestScreen({
    Key? key,
    required this.productsRepository,
    required this.historyRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products Repository Test"),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      HistoryRepositoryTestScreen(
                    historyRepository: historyRepository,
                    productsRepository: productsRepository,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.history_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: productsRepository.products,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Product product = snapshot.data![index];
                      return ListTile(
                        leading: Text("${product.id}."),
                        title: Text(product.name),
                        subtitle: Text(
                            "${product.code} - ${product.actualStock}/${product.previousStock}"),
                        onTap: () {
                          Product updatedProduct = product.copyWith(
                            actualStock:
                                product.actualStock + Random().nextInt(10) + 1,
                            name: "${product.name} UPDATED",
                          );
                          productsRepository.updateProduct(updatedProduct);
                          historyRepository.addActivity(
                            product,
                            updatedProduct,
                          );
                        },
                        onLongPress: () {
                          historyRepository.addActivity(product, null);
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
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              historyRepository.addActivity(
                null,
                productsRepository.addProduct(
                  Product(
                    name: "Produkt testowy nr ${Random().nextInt(100) + 1}",
                    code: "TEST TEST TEST TEST TEST",
                    previousStock: Random().nextInt(15) + 5,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

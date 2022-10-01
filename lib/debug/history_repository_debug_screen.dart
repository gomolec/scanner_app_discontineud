import 'package:flutter/material.dart';

import 'package:scanner_app/repositories/products_repository.dart';

import '../models/models.dart';
import '../repositories/history_repository.dart';

class HistoryRepositoryDebugScreen extends StatelessWidget {
  final HistoryRepository historyRepository;
  final ProductsRepository productsRepository;

  const HistoryRepositoryDebugScreen({
    Key? key,
    required this.historyRepository,
    required this.productsRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History Repository Test")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: historyRepository.history,
              builder: (BuildContext context,
                  AsyncSnapshot<List<HistoryAction>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      HistoryAction historyAction = snapshot.data![index];
                      return ListTile(
                        leading: Text("isRedo: ${historyAction.isRedo}."),
                        title: Text(
                          () {
                            String title = "${historyAction.id})";
                            if (historyAction.oldProduct != null &&
                                historyAction.updatedProduct == null) {
                              title +=
                                  " Usunięto ${historyAction.oldProduct!.name}";
                            } else if (historyAction.oldProduct == null &&
                                historyAction.updatedProduct != null) {
                              title +=
                                  " Dodano ${historyAction.updatedProduct!.name}";
                            } else if (historyAction.oldProduct != null &&
                                historyAction.updatedProduct != null) {
                              title +=
                                  " Zmieniono ${historyAction.oldProduct!.name}";
                            }
                            return title;
                          }(),
                        ),
                        subtitle: Text(
                          () {
                            String title = "";
                            if (historyAction.oldProduct != null &&
                                historyAction.updatedProduct != null) {
                              title +=
                                  "przed: ${historyAction.oldProduct!.actualStock}/${historyAction.oldProduct!.previousStock}\npo: ${historyAction.updatedProduct!.actualStock}/${historyAction.updatedProduct!.previousStock}";
                            }
                            return title;
                          }(),
                        ),
                        trailing:
                            (historyRepository.currentActivityIndex == index)
                                ? const Icon(Icons.adjust_rounded)
                                : const SizedBox(),
                        onTap: () {},
                        onLongPress: () {},
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
            heroTag: null,
            child: const Icon(Icons.undo_rounded),
            onPressed: () {
              final HistoryAction? undoAction = historyRepository.undo();
              if (undoAction != null) {
                if (undoAction.oldProduct == null &&
                    undoAction.updatedProduct != null) {
                  productsRepository
                      .deleteProduct(undoAction.updatedProduct!.id);
                } else if (undoAction.oldProduct != null &&
                    undoAction.updatedProduct == null) {
                  productsRepository.addProduct(undoAction.oldProduct!);
                } else {
                  productsRepository.updateProduct(undoAction.oldProduct!);
                }
              }
            },
          ),
          FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.redo_rounded),
            onPressed: () {
              final HistoryAction? redoAction = historyRepository.redo();
              if (redoAction != null) {
                if (redoAction.oldProduct == null &&
                    redoAction.updatedProduct != null) {
                  productsRepository.addProduct(redoAction.updatedProduct!);
                } else if (redoAction.oldProduct != null &&
                    redoAction.updatedProduct == null) {
                  productsRepository.deleteProduct(redoAction.oldProduct!.id);
                } else {
                  productsRepository.updateProduct(redoAction.updatedProduct!);
                }
              }
            },
          )
        ],
      ),
    );
  }
}

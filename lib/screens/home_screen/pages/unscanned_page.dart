import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubits/products_cubit/products_cubit.dart';
import '../../../cubits/sessions_cubit/sessions_cubit.dart';
import '../widgets/product_tile.dart';

class UnscannedPage extends StatelessWidget {
  const UnscannedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoaded) {
          return ListView.builder(
            itemCount: state.unscannedProducts.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductTile(product: state.unscannedProducts[index]);
            },
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Brak aktywnej sesji.\nPrzywróć poprzednio utworzoną lub utwórz nową sesję i zacznij skanować!",
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<SessionsCubit>().createNewSession();
                    },
                    icon: const Icon(Icons.create_new_folder_rounded),
                    label: const Text("Utwórz nową sesję"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/sessions_history');
                    },
                    icon: const Icon(Icons.history_rounded),
                    label: const Text("Historia sesji"),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

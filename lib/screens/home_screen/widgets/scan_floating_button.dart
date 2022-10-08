import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../cubits/products_cubit/products_cubit.dart';
import '../../../providers/search_bar_provider.dart';

class ScanFloatingButton extends StatelessWidget {
  const ScanFloatingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        return Consumer<SearchBarProvider>(
          builder: (context, value, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: state is ProductsLoaded ? () {} : null,
                  tooltip: 'Scan',
                  child: const Icon(Icons.document_scanner_rounded),
                ),
                SizedBox(
                  height: value.isSearching ? kToolbarHeight : 0,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

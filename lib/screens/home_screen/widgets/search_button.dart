import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/cubits/products_cubit/products_cubit.dart';
import 'package:scanner_app/providers/search_bar_provider.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchBarProvider = context.select(
      (SearchBarProvider searchBarProvider) => searchBarProvider.isSearching,
    );

    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        return IconButton(
          onPressed: state is ProductsLoaded
              ? () {
                  context.read<SearchBarProvider>().toggleSearching();
                  context.read<ProductsCubit>().getQueriedProductList("");
                }
              : null,
          icon: searchBarProvider
              ? const Icon(
                  Icons.search_off_rounded,
                  color: Color(0xFFFF4444),
                )
              : const Icon(Icons.search_rounded),
          tooltip: 'Search',
        );
      },
    );
  }
}

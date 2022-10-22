import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/cubits/products_cubit/products_cubit.dart';
import 'package:scanner_app/providers/search_bar_provider.dart';

class SearchBar extends StatelessWidget {
  SearchBar({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchBarProvider>(builder: (context, value, child) {
      if (value.isSearching != true) {
        return const SizedBox();
      }
      return WillPopScope(
        onWillPop: () {
          context.read<SearchBarProvider>().toggleSearching();
          context.read<ProductsCubit>().getQueriedProductList("");
          return Future.value(false);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: TextField(
            autofocus: true,
            controller: _controller,
            onChanged: (value) {
              context.read<SearchBarProvider>().updateQuery(value);
              context.read<ProductsCubit>().getQueriedProductList(value);
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: value.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        context.read<SearchBarProvider>().updateQuery("");
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
              hintText: "Wyszukaj tekst",
            ),
          ),
        ),
      );
    });
  }
}

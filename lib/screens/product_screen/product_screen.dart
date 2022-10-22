import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/cubits/products_cubit/products_cubit.dart';
import 'package:scanner_app/screens/product_screen/widgets/pin_button.dart';
import 'package:scanner_app/screens/product_screen/widgets/product_image.dart';
import 'package:scanner_app/screens/product_screen/widgets/product_link_button.dart';
import 'package:scanner_app/screens/product_screen/widgets/quantity_buttons.dart';
import 'package:scanner_app/services/krukam_urls_service.dart';

import '../../models/models.dart';
import '../../providers/quantity_provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final KrukamUrlsService linksService = KrukamUrlsService();

    bool isPinned = product.isPinned;
    void setPin(bool value) {
      isPinned = value;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Szczegóły produktu"),
        actions: [
          PinButton(
            initialValue: isPinned,
            setPin: setPin,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ProductsCubit>().updateProduct(product.copyWith(
                actualStock: context.read<QuantityProvider>().actualValue,
                isPinned: isPinned,
              ));
          Navigator.pop(context);
        },
        tooltip: 'Save',
        child: const Icon(Icons.save_rounded),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImage(
                product: product,
                linkService: linksService,
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 8),
              Text(
                product.code,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 16),
              Center(
                child: QuantityButtons(
                  height: MediaQuery.of(context).size.height * 0.16,
                  width: MediaQuery.of(context).size.height * 0.5,
                ),
              ),
              const SizedBox(height: 8),
              ProductLinkButton(
                product: product,
                linkService: linksService,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

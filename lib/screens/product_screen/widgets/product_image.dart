import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';
import '../../../cubits/sessions_cubit/sessions_cubit.dart';
import '../../../models/models.dart';
import '../../../services/krukam_urls_service.dart';
import 'download_products_images_dialog.dart';

class ProductImage extends StatelessWidget {
  final KrukamUrlsService linkService;
  final Product product;

  const ProductImage({
    Key? key,
    required this.linkService,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.16),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(24))),
        child: Stack(
          children: [
            BlocBuilder<SessionsCubit, SessionsState>(
              builder: (context, state) {
                if (state is SessionsLoaded && state.actualSession != null) {
                  if (state.actualSession!.downloadImages == true) {
                    return FutureBuilder<String?>(
                      future: linkService.getImageUrl(product.code),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Image(
                            height: double.infinity,
                            width: double.infinity,
                            image: NetworkImage(
                              snapshot.data.toString(),
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  }
                }
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: greyColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(24),
                    ),
                  ),
                  child: Icon(
                    Icons.image_outlined,
                    color: greyColor,
                    size: MediaQuery.of(context).size.height * 0.16,
                  ),
                );
              },
            ),
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  icon: Icon(
                    Icons.info_outline_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const DownloadProductsImagesDialog();
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

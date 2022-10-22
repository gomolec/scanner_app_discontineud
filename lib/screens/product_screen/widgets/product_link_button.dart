import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:scanner_app/cubits/sessions_cubit/sessions_cubit.dart';

import '../../../globals.dart';
import '../../../models/models.dart';
import '../../../services/krukam_urls_service.dart';

class ProductLinkButton extends StatelessWidget {
  final KrukamUrlsService linkService;
  final Product product;

  const ProductLinkButton({
    Key? key,
    required this.linkService,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        if (state is SessionsLoaded && state.actualSession != null) {
          if (state.actualSession!.downloadImages == true) {
            return Center(
              child: FutureBuilder<String?>(
                future: linkService.getLinkUrl(product.code),
                builder: (context, AsyncSnapshot snapshot) {
                  return TextButton.icon(
                    onPressed: (snapshot.hasData && snapshot.data != null)
                        ? () async {
                            Uri linkUri = Uri.parse(snapshot.data);
                            if (await canLaunchUrl(linkUri)) {
                              if (!await launchUrl(
                                linkUri,
                                mode: LaunchMode.externalApplication,
                              )) {
                                snackbarKey.currentState?.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Wystąpił błąd podczas otwierania strony: \n${linkUri.toString()}",
                                    ),
                                  ),
                                );
                              }
                            } else {
                              snackbarKey.currentState?.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Wystąpił błąd podczas otwierania strony. \n Nieobsługiwana przeglądarka.",
                                  ),
                                ),
                              );
                            }
                          }
                        : null,
                    icon: const Icon(Icons.link_rounded),
                    label: const Text("Artykuł na stronie internetowej"),
                  );
                },
              ),
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/constants.dart';

import '../../../provider/quantity_provider.dart';

class QuantityButtons extends StatelessWidget {
  final double width;
  final double height;

  const QuantityButtons({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              context.read<QuantityProvider>().decrement();
            },
            onLongPress: () {
              context.read<QuantityProvider>().setValue(0);
            },
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: redColor,
                ),
                child: Icon(
                  Icons.remove_rounded,
                  color: Colors.white,
                  size: height * 0.6,
                ),
              ),
            ),
          ),
          SizedBox(
            width: width - (2 * height) - 8,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Consumer(
                      builder: (context, QuantityProvider quantity, child) {
                        controller.text = quantity.actualValue.toString();
                        return TextField(
                          textAlign: TextAlign.center,
                          controller: controller,
                          onSubmitted: (value) {
                            int? newValue = int.tryParse(value);
                            if (newValue != null) {
                              quantity.setValue(newValue);
                            }
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: () {
                            if (quantity.actualValue ==
                                quantity.previousValue) {
                              return greenColor;
                            } else if (quantity.actualValue >
                                quantity.previousValue) {
                              return redColor;
                            } else if (quantity.actualValue == 0) {
                              return greyColor;
                            } else if (quantity.actualValue <
                                quantity.previousValue) {
                              return yellowColor;
                            }
                          }()),
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  " / ",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      context.read<QuantityProvider>().previousValue.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              context.read<QuantityProvider>().increment();
            },
            onLongPress: () {
              context.read<QuantityProvider>().setPreviousValue();
            },
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: greenColor,
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: height * 0.6,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scanner_app/constants.dart';

class PinButton extends StatefulWidget {
  final bool initialValue;
  final Function(bool) setPin;

  const PinButton({
    Key? key,
    required this.initialValue,
    required this.setPin,
  }) : super(key: key);

  @override
  State<PinButton> createState() => _PinButtonState();
}

class _PinButtonState extends State<PinButton> {
  late bool _isPinned;

  @override
  void initState() {
    _isPinned = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _isPinned = !_isPinned;
          widget.setPin(_isPinned);
        });
      },
      tooltip: "Pin",
      icon: const Icon(Icons.flag_rounded),
      color: _isPinned ? redColor : Theme.of(context).disabledColor,
    );
  }
}

import 'package:flutter/material.dart';

class ExportServiceDebugScreen extends StatelessWidget {
  const ExportServiceDebugScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ExportServiceDebugScreen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Test Export"),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.home_repair_service_rounded),
              title: const Text("DEBUG"),
              onTap: () {
                Navigator.popAndPushNamed(context, "/debug");
              },
            ),
          ],
        ),
      ),
    );
  }
}

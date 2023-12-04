import 'package:flutter/material.dart';

void showBanner(GlobalKey<ScaffoldState> key, Widget child, Function callback) {
  ScaffoldMessenger.of(key.currentState!.context).hideCurrentMaterialBanner();
  ScaffoldMessenger.of(key.currentState!.context).showMaterialBanner(
    MaterialBanner(
      backgroundColor: Colors.black,
      leading: const Icon(
        Icons.delete,
        color: Colors.greenAccent,
      ),
      content: child,
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(key.currentState!.context)
                .hideCurrentMaterialBanner();
          },
          child: const Text('Submit'),
        ),
      ],
    ),
  );
}

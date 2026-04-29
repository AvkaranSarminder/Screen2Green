import 'package:flutter/material.dart';
import 'package:screen2green/components/enums/snackbar_type.dart'
    show SnackBarType;

class MySnackBar extends StatelessWidget {
  const MySnackBar({super.key, required this.label, required this.type});

  final String label;
  final SnackBarType type;

  @override
  Widget build(BuildContext context) {
    Icon icon;
    switch (type) {
      case SnackBarType.error:
        icon = const Icon(Icons.error);
        break;
      case SnackBarType.success:
        icon = const Icon(Icons.check);
        break;
      case SnackBarType.info:
        icon = const Icon(Icons.info);
        break;
    }

    Color backgroundColor;
    switch (type) {
      case SnackBarType.error:
        backgroundColor = Colors.red;
        break;
      case SnackBarType.success:
        backgroundColor = Colors.green;
        break;
      case SnackBarType.info:
        backgroundColor = Colors.blue;
        break;
    }

    return SnackBar(
      content: Row(children: [icon, const SizedBox(width: 8), Text(label)]),
      backgroundColor: backgroundColor,
    );
  }
}

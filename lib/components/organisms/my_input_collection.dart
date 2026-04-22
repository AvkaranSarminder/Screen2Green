import 'package:flutter/material.dart';
import 'package:screen2green/components/atoms/my_toast_content.dart';
import 'package:screen2green/components/molecules/my_special_text_field.dart';

class MyInputCollection extends StatelessWidget {
  const MyInputCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MySpecialTextField(
          handleSubmit: (text) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: MyToastContent('Hello $text!')));
          },
        ),
      ],
    );
  }
}

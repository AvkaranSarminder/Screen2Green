import 'package:flutter/material.dart';
import 'package:screen2green/components/molecules/toast_button.dart';
import 'package:screen2green/components/organisms/my_input_collection.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ToastButton('Show Toast'), MyInputCollection()],
          ),
        ),
      ),
    );
  }
}

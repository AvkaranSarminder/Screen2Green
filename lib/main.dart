import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
        appBar: AppBar(
          title: Image.asset(
            'assets/images/tempor-removebg-preview.png',
            height: 61,
          ),
        ),
      ),
    );
  }
}

class MyToastContent extends StatelessWidget {
  const MyToastContent(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label);
  }
}

class MySpecialButton extends StatelessWidget {
  const MySpecialButton(this.label, this.onPressed, {super.key});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}

class ToastButton extends StatelessWidget {
  const ToastButton(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return MySpecialButton(label, () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: MyToastContent('Yoooo button pressed here!')),
      );
    });
  }
}

class MySpecialTextField extends StatelessWidget {
  MySpecialTextField({super.key, required this.handleSubmit});

  final void Function(String) handleSubmit;

  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  void handleInput() {
    handleSubmit(_controller.text.trim());
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
              labelText: 'Enter your firstname',
            ),
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            onSubmitted: (input) {
              handleInput();
            },
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_circle_up),
          onPressed: () {
            handleInput();
          },
        ),
      ],
    );
  }
}

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

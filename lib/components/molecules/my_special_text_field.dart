import 'package:flutter/material.dart';

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

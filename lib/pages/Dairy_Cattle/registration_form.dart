import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  final controller;
  final hintsText;
  final requiredMessage;
  const RegisterForm({super.key,
  required this.controller,
    required this.hintsText,
    required this.requiredMessage
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.green,
            )
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: Colors.green,
          decoration:  InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: hintsText,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return requiredMessage;
            }
            return null;
          },
        ),
      ),
    );
  }
}

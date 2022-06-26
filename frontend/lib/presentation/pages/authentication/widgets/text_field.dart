import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  const EmailTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      decoration: const InputDecoration(hintText: 'Email'),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Cannot be empty';
        } else if (!RegExp(r"[^\s@]+@[^\s@]+\.[^\s@]+").hasMatch(v)) {
          return 'Not a valid email address';
        }
        return null;
      },
    );
  }
}

class NameTextField extends StatelessWidget {
  final TextEditingController controller;
  const NameTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      autofillHints: const [AutofillHints.name],
      decoration: const InputDecoration(hintText: 'Name'),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Cannot be empty';
        }
        return null;
      },
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  const PasswordTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofillHints: const [AutofillHints.newPassword],
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: const InputDecoration(hintText: 'Password'),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Cannot be empty';
        } else if (v.length < 8) {
          return 'Password should be more than 8 character';
        }
        return null;
      },
    );
  }
}

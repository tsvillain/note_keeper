import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class TitleTextField extends StatelessWidget {
  final TextEditingController controller;
  const TitleTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.titleLarge,
      decoration: InputDecoration(
        border: InputBorder.none,
        isDense: true,
        hintText: "Title",
        hintStyle: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class ContentTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool focus;
  const ContentTextField(
      {Key? key, required this.controller, this.focus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyMedium,
      autofocus: focus,
      decoration: InputDecoration(
        border: InputBorder.none,
        isDense: true,
        hintText: "Note",
        hintStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class RichContentTextField extends StatelessWidget {
  final QuillController controller;
  final bool focus;
  final bool write;
  const RichContentTextField(
      {Key? key,
      required this.controller,
      this.focus = false,
      this.write = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      controller: controller,
      readOnly: !write,
    );
  }
}

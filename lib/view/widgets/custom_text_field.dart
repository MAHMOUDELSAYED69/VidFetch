import 'package:flutter/material.dart';
import 'package:vid_fetch/utils/extentions/extentions.dart';

import '../../utils/constants/colors.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    this.onSaved,
    this.controller,
    this.focusNode,
  });
  final FormFieldSetter<String>? onSaved;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      style: context.textTheme.bodySmall,
      cursorColor: ColorManager.darkGrey,
      keyboardType: TextInputType.url,
      controller: controller,
      onSaved: onSaved,
      validator: _youtubeLinkValidator,
      decoration: const InputDecoration(
        isCollapsed: true,
        isDense: true,
        filled: true,
        hintText: "Paste Youtube Link",
      ),
    );
  }

  String? _youtubeLinkValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a YouTube link';
    }

    RegExp youtubeRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/(watch\?v=|shorts\/|embed\/|v\/|e\/|.+\?v=)?([^&=%\?]{11})',
      caseSensitive: false,
      multiLine: false,
    );

    if (!youtubeRegex.hasMatch(value)) {
      return 'Please enter a valid YouTube link';
    }

    return null;
  }
}

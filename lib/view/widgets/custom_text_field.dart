import 'package:flutter/material.dart';
import 'package:vid_fetch/utils/extentions/extentions.dart';

import '../../utils/constants/colors.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    this.hintText,
    this.onSaved,
    this.onChanged,
    this.onFieldSubmitted,
    this.controller,
    this.initialValue,
  });
  final String? hintText;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextEditingController? controller;
  final String? initialValue;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
     
      initialValue: initialValue,
      style: context.textTheme.bodySmall,
      cursorColor: ColorManager.darkGrey,
      keyboardType: TextInputType.url,
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      onChanged: onChanged,
      decoration: InputDecoration(
        isCollapsed: true,
        isDense: true,
        filled: true,
        hintText: hintText,
      ),
    );
  }
}

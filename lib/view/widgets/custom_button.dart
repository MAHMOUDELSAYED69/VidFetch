import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vid_fetch/utils/extentions/extentions.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton({
    super.key,
    this.title,
    this.onPressed,
    this.widget,
    this.size,

    this.isDisabled,
  });
  final bool? isDisabled;
  final String? title;
  final void Function()? onPressed;
  final Size? size;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: context.elevatedButtonTheme.style?.copyWith(
          fixedSize: WidgetStatePropertyAll(
            size ?? Size(context.width, 40.h),
          ),
        ),
        onPressed: isDisabled == true ? null : onPressed,
        child: widget ??
            Text(
              title ?? "",
              style: context.textTheme.bodyMedium,
            ));
  }
}

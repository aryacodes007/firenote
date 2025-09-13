import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// [PrimaryTextButton]
///
/// A reusable [stateless widget] for creating [text buttons] with a
/// [background color], [text label], and [onPressed] callback.
///
/// Automatically fills the [available width] and applies consistent [height],
/// [padding], and [border radius] for all buttons in the app.
///
/// Example:
/// ```dart
/// PrimaryTextButton(
///   text: "Save",
///   backgroundColor: Colors.blue,
///   onPressed: () {
///     // handle button tap
///   },
/// )
/// ```
class PrimaryTextButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final void Function()? onPressed;

  const PrimaryTextButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.surface,
        backgroundColor: backgroundColor,
        minimumSize: Size(
          double.infinity,
          54.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.w),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: colorScheme.surface,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

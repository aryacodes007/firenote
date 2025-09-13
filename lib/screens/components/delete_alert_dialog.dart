import 'package:flutter/material.dart';
import 'package:firenote/firenote.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// [DeleteAlertDialog]
///
/// A reusable [stateless widget] that displays a [confirmation dialog]
/// for [deleting] a [note].
///
/// Features:
/// - Displays [title] and [message] from [AppConsts].
/// - Provides [Cancel] and [Delete] [TextButton] actions with custom colors.
/// - Supports [rounded corners] and [responsive padding].
///
/// Example:
/// ```dart
/// showDeleteAlertDialog(
///   onDelete: () {
///     // handle delete
///   },
///   onCancel: () {
///     // handle cancel
///   },
///   context: context,
/// );
/// ```
class DeleteAlertDialog extends StatelessWidget {
  final void Function() onDelete;
  final void Function() onCancel;

  const DeleteAlertDialog({
    super.key,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.w),
      ),
      title: Text(
        AppConsts.deleteNote,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorScheme.error,
          fontSize: 18.sp,
        ),
      ),
      content: Text(
        AppConsts.deleteNoteMessage,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
      ),
      actions: [
        _textButton(
          text: AppConsts.cancel,
          textColor: colorScheme.onSurface,
          onPressed: onCancel,
        ),
        _textButton(
          text: AppConsts.delete,
          textColor: colorScheme.error,
          onPressed: onDelete,
        ),
      ],
    );
  }

  static TextButton _textButton({
    required String text,
    required Color textColor,
    required void Function() onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        padding: EdgeInsets.all(10.w),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}

/// Displays a [DeleteAlertDialog] with a [fade + scale transition].
///
/// Returns a [Future<bool?>] indicating whether [Delete] was confirmed (`true`)
/// or [Cancel] was pressed (`false`).
Future<bool?> showDeleteAlertDialog({
  required void Function() onDelete,
  required void Function() onCancel,
  required BuildContext context,
}) {
  return showGeneralDialog<bool?>(
    context: context,
    transitionDuration: Durations.medium2,
    transitionBuilder: (_, animate, __, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animate,
          curve: Curves.easeOutBack,
        ),
        child: FadeTransition(
          opacity: animate,
          child: child,
        ),
      );
    },
    pageBuilder: (a, b, c) => DeleteAlertDialog(
      onDelete: onDelete,
      onCancel: onCancel,
    ),
  );
}

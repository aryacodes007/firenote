import 'package:firenote/firenote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// [NotesCard]
///
/// A reusable [stateless widget] representing a single [note] in a [list].
/// Displays the [note text] and triggers an [onTap] callback when tapped.
///
/// Features:
/// - [Card] with rounded corners and subtle [elevation].
/// - [InkWell] ripple effect using [splashColor].
/// - Single-line text display with [ellipsis overflow] for long notes.
///
/// Example:
/// ```dart
/// NotesCard(
///   note: "My first note",
///   onTap: () {
///     showNoteDetailsScreen(
///       noteId: "123",
///       content: "My first note",
///       context: context,
///     );
///   },
/// )
/// ```
class NotesCard extends StatelessWidget {
  final String note;
  final VoidCallback onTap;

  const NotesCard({
    super.key,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final splashColor = colorScheme.primary.withAlpha(
      0.2.opacity,
    );

    return Card(
      color: colorScheme.surface,
      shadowColor: colorScheme.primary,
      elevation: 1.2.w,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.w),
        splashColor: splashColor,
        highlightColor: splashColor,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 8.w,
          ),
          child: Text(
            note,
            style: TextStyle(
              fontSize: 16.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

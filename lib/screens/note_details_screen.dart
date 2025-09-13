import 'package:firenote/firenote.dart';
import 'package:firenote/screens/components/delete_alert_dialog.dart';
import 'package:firenote/screens/components/primary_text_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// [NoteDetailScreen]
///
/// A [stateless widget] that displays the full [content] of a selected [note].
/// Provides the option to [delete] the note with a confirmation [dialog].
///
/// Example:
/// ```dart
/// showNoteDetailsScreen(
///   noteId: "123",
///   content: "My first note",
///   context: context,
/// );
/// ```
class NoteDetailScreen extends StatelessWidget {
  final String noteId;
  final String content;

  const NoteDetailScreen({
    super.key,
    required this.noteId,
    required this.content,
  });

  Future<void> _deleteNote(BuildContext context) async {
    final internetConnection =
        await ServiceUtils.checkInternetConnection(context);
    if (!internetConnection) return;

    final isDelete = await showDeleteAlertDialog(
          onDelete: () => Navigator.pop(context, true),
          onCancel: () => Navigator.pop(context),
          context: context,
        ) ??
        false;

    if (isDelete) {
      final internetConnection =
          await ServiceUtils.checkInternetConnection(context);
      if (!internetConnection) return;

      await FirebaseFirestore.instance
          .collection(
            AppConsts.notesKey,
          )
          .doc(noteId)
          .delete();

      // Close detail screen after delete
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppConsts.noteDetails,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 15.h,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 15.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(
                      0.1.opacity,
                    ),
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: scrollController,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Text(
                          content,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Text Button - Delete
              PrimaryTextButton(
                text: AppConsts.delete,
                backgroundColor: colorScheme.error,
                onPressed: () => _deleteNote(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens the [NoteDetailScreen] inside a [dialog] with a [fade transition].
///
/// This allows the user to view and optionally [delete] a note without
/// navigating away from the main [screen].
void showNoteDetailsScreen({
  required String noteId,
  required String content,
  required BuildContext context,
}) {
  showGeneralDialog(
    context: context,
    transitionDuration: Durations.medium2,
    transitionBuilder: (_, animate, __, child) {
      return FadeTransition(
        opacity: animate,
        child: child,
      );
    },
    pageBuilder: (a, b, c) => NoteDetailScreen(
      noteId: noteId,
      content: content,
    ),
  );
}

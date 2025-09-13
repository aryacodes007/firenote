import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firenote/firenote.dart';
import 'package:firenote/screens/components/primary_text_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// [NotesListScreen]
///
/// A [stateful widget] that displays all saved [notes] in a [list],
/// and allows users to [add] new notes.
///
/// Features:
/// - Shows a real-time [list] of notes using [Firestore snapshots].
/// - Supports [offline persistence] with cached data.
/// - Displays [no notes available] or [no internet connection] messages.
/// - Provides a [TextFormField] with validation for adding notes.
/// - Includes a [Save] button that is only enabled when the note is valid.
class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

/// [_NotesListScreenState]
///
/// The [state] for [NotesListScreen].
/// Handles [Firestore queries], [note saving], [validation],
/// and [UI updates].
class _NotesListScreenState extends State<NotesListScreen> {
  final _controller = TextEditingController();
  final _notesScrollController = ScrollController();
  final _textsScrollController = ScrollController();

  final _isValidNotes = ValueNotifier<bool>(false);

  final _notesRef = FirebaseFirestore.instance.collection(
    AppConsts.notesKey,
  );

  Future<void> _saveNote(BuildContext context) async {
    final internetConnection =
        await ServiceUtils.checkInternetConnection(context);
    if (!internetConnection) return;

    await _notesRef.add({
      AppConsts.contentKey: _controller.text.trim(),
      AppConsts.createdAtKey: FieldValue.serverTimestamp(),
    });

    _controller.clear();
    _isValidNotes.value = false;
    ServiceUtils.keyboardClosed();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppConsts.notes,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // StreamBuilder - Notes List
            Expanded(
              child: Builder(
                builder: (context) {
                  return StreamBuilder(
                    stream: Connectivity()
                        .onConnectivityChanged
                        .asBroadcastStream(),
                    builder: (context, internet) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: _notesRef
                            .orderBy(AppConsts.createdAtKey, descending: true)
                            .snapshots(
                              source: ListenSource.cache,
                            ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final docs = snapshot.data?.docs ?? [];

                          if (docs.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Center(
                                child: Text(
                                  internet.data?.contains(
                                            ConnectivityResult.none,
                                          ) ==
                                          false
                                      ? AppConsts.noNotesAvailable
                                      : AppConsts.noInternetConnection
                                          .replaceAll('. ', '.\n'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Scrollbar(
                            controller: _notesScrollController,
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 12.w,
                              ),
                              child: ListView.separated(
                                controller: _notesScrollController,
                                itemCount: docs.length,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                ),
                                itemBuilder: (context, index) {
                                  final doc = docs[index];
                                  return NotesCard(
                                    note: doc[AppConsts.contentKey],
                                    onTap: () => showNoteDetailsScreen(
                                      noteId: doc.id,
                                      content: doc[AppConsts.contentKey],
                                      context: context,
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 10.h,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // TextFormField and Text Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.w,
              ),
              child: Column(
                spacing: 15.h,
                children: [
                  // TextFormField with Scrollbar - Enter Note
                  Scrollbar(
                    controller: _textsScrollController,
                    thumbVisibility: true,
                    child: TextFormField(
                      controller: _controller,
                      maxLines: 3,
                      minLines: 1,
                      onTapUpOutside: (_) => ServiceUtils.keyboardClosed(),
                      onTapOutside: (_) => ServiceUtils.keyboardClosed(),
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                      onChanged: (notes) {
                        if (!_isValidNotes.value && notes.trim().length > 2) {
                          _isValidNotes.value = true;
                        } else if (_isValidNotes.value &&
                            notes.trim().length <= 2) {
                          _isValidNotes.value = false;
                        }
                      },
                      inputFormatters: [TrimTextFormatters()],
                      scrollController: _textsScrollController,
                      decoration: InputDecoration(
                        hintText: AppConsts.enterNote,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                      ),
                    ),
                  ),

                  // TextButton - Save
                  ValueListenableBuilder(
                    valueListenable: _isValidNotes,
                    builder: (context, isValidNotes, child) {
                      return PrimaryTextButton(
                        text: AppConsts.save,
                        backgroundColor: !isValidNotes
                            ? colorScheme.onSurface.withAlpha(
                                0.4.opacity,
                              )
                            : colorScheme.primary,
                        onPressed:
                            !isValidNotes ? null : () => _saveNote(context),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

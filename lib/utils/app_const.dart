/// [AppConsts]
///
/// A centralized [collection] of constant [strings] used throughout [FireNote].
/// This avoids hardcoding [text] in widgets and makes it easier to [update] or [localize].
///
/// Example:
/// `Text(AppConsts.noNotesAvailable)`
class AppConsts {
  static const String appTitle = 'FireNote';

  static const String notes = 'Notes';
  static const String noteDetails = 'Note Details';
  static const String enterNote = 'Enter note';
  static const String noNotesAvailable =
      'No notes available.\nShare your first note.';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';

  static const String deleteNote = 'Delete Note!';
  static const String deleteNoteMessage =
      'Are you sure you want to delete this note?';

  static const String notesKey = 'notes';
  static const String contentKey = 'content';
  static const String createdAtKey = 'createdAt';

  static const String noInternetConnection =
      'No internet connection. Please check your connection and try again.';
}

import 'package:flutter/services.dart';

/// [TrimTextFormatters]
///
/// A custom [TextInputFormatter] that prevents leading spaces in user input.
/// If the new value starts with a space, all spaces are removed from the text
/// and the cursor is reset at the end of the trimmed text.
class TrimTextFormatters extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.startsWith(' ')
          ? newValue.text.replaceAll(' ', '')
          : newValue.text,
      selection: newValue.text.startsWith(' ')
          ? TextSelection.collapsed(
              offset: newValue.text.replaceAll(' ', '').length,
            )
          : newValue.selection,
    );
  }
}

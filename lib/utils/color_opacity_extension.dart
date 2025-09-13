/// [ColorOpacityExtension]
///
/// Provides a convenient way to convert a [numeric] value in the [range] `0.0–1.0`
/// to an integer [opacity] value (`0–255`) for use in Flutter [colors].
///
/// Example:
/// Colors.black.withAlpha(0.5.opacity); // 50% opacity
extension ColorOpacityExtension on num {
  int get opacity => (this * 255).round();
}

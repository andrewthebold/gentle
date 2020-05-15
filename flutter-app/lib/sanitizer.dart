import 'package:gentle/constants.dart';
import 'package:characters/characters.dart';

class Sanitizer {
  static const blacklistRegex = '/[^\w\s\p{P}\$^=+~`|<>]/g';
  static const whitelistRegex = r'[\w\s\p{P}\p{N}\p{Sm}\p{Sc}$^=+~`|<>]';

  static String sanitizeUserInputExcerpt(String input) {
    if (input == null || input is! String) {
      return '';
    }

    var output = Sanitizer.sanitizeUserInput(input).replaceAll('\n', ' ');

    // Ensure the text has the right length limit
    if (output.characters.length > Constants.maxExcerptLength) {
      output = output.characters.take(Constants.maxExcerptLength).toString();
    }

    return output;
  }

  static String sanitizeUserInput(String input) {
    if (input == null || input is! String) {
      return '';
    }

    return input.trim().replaceAll(RegExp(blacklistRegex, unicode: true), '');
  }
}

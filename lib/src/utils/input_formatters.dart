import 'package:flutter/services.dart';

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final buffer = StringBuffer();
    var nonDigits = 0;
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (char.runes.first >= 48 && char.runes.first <= 57) {
        // Check if it's a digit
        if (nonDigits >= 11) {
          // Restrict to 11 digits
          break;
        }
        if (nonDigits == 3 || nonDigits == 6) {
          buffer.write('.');
        } else if (nonDigits == 9) {
          buffer.write('-');
        }
        buffer.write(char);
        nonDigits++;
      }
    }

    final result = buffer.toString();
    return newValue.copyWith(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final buffer = StringBuffer();
    var nonDigits = 0;
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (char.runes.first >= 48 && char.runes.first <= 57) {
        // Check if it's a digit
        if (nonDigits >= 11) {
          // Restrict to 11 digits (2 for DDD, 9 for number)
          break;
        }

        if (nonDigits == 0) {
          buffer.write('(');
        }
        if (nonDigits == 2) {
          buffer.write(') ');
        }
        if (nonDigits == 7) {
          buffer.write('-');
        }
        buffer.write(char);
        nonDigits++;
      }
    }

    final result = buffer.toString();
    return newValue.copyWith(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final buffer = StringBuffer();
    var nonDigits = 0;
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (char.runes.first >= 48 && char.runes.first <= 57) {
        // Check if it's a digit
        if (nonDigits >= 8) {
          // Restrict to 8 digits (DDMMYYYY)
          break;
        }

        if (nonDigits == 2 || nonDigits == 4) {
          buffer.write('/');
        }
        buffer.write(char);
        nonDigits++;
      }
    }

    final result = buffer.toString();
    return newValue.copyWith(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final buffer = StringBuffer();
    var nonDigits = 0;
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (char.runes.first >= 48 && char.runes.first <= 57) {
        // Check if it's a digit
        if (nonDigits >= 8) {
          // Restrict to 8 digits
          break;
        }

        if (nonDigits == 5) {
          buffer.write('-');
        }
        buffer.write(char);
        nonDigits++;
      }
    }

    final result = buffer.toString();
    return newValue.copyWith(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

class CreditCardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final buffer = StringBuffer();
    var nonDigits = 0;
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (char.runes.first >= 48 && char.runes.first <= 57) {
        // Check if it's a digit
        if (nonDigits >= 16) {
          // Restrict to 16 digits
          break;
        }

        if (nonDigits > 0 && nonDigits % 4 == 0) {
          buffer.write(' ');
        }
        buffer.write(char);
        nonDigits++;
      }
    }

    final result = buffer.toString();
    return newValue.copyWith(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

class CreditCardValidityInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final buffer = StringBuffer();
    var nonDigits = 0;
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (char.runes.first >= 48 && char.runes.first <= 57) {
        // Check if it's a digit
        if (nonDigits >= 4) {
          // Restrict to 4 digits (MMYY)
          break;
        }

        if (nonDigits == 2) {
          buffer.write('/');
        }
        buffer.write(char);
        nonDigits++;
      }
    }

    final result = buffer.toString();
    return newValue.copyWith(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

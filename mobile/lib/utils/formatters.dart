import 'package:flutter/services.dart';

TextEditingValue _withDigitsMasked(
  TextEditingValue newValue,
  String Function(String digits) format,
  int maxDigits,
) {
  final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
  final trimmed = digits.length > maxDigits ? digits.substring(0, maxDigits) : digits;
  final formatted = format(trimmed);

  return TextEditingValue(
    text: formatted,
    selection: TextSelection.collapsed(offset: formatted.length),
  );
}

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return _withDigitsMasked(newValue, (d) {
      if (d.length <= 5) return d;
      return '${d.substring(0, 5)}-${d.substring(5)}';
    }, 8);
  }
}

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return _withDigitsMasked(newValue, (d) {
      final parts = <String>[];
      if (d.isNotEmpty) parts.add(d.substring(0, d.length >= 3 ? 3 : d.length));
      if (d.length > 3) parts.add(d.substring(3, d.length >= 6 ? 6 : d.length));
      if (d.length > 6) parts.add(d.substring(6, d.length >= 9 ? 9 : d.length));
      var out = parts.join('.');
      if (d.length > 9) out += '-${d.substring(9)}';
      return out;
    }, 11);
  }
}

class WhatsappInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return _withDigitsMasked(newValue, (d) {
      if (d.isEmpty) return d;
      final ddd = d.substring(0, d.length >= 2 ? 2 : d.length);
      if (d.length <= 2) return '($ddd';
      final rest = d.substring(2);
      final splitAt = rest.length > 4 ? (d.length > 10 ? 5 : 4) : rest.length;
      final part1 = rest.substring(0, splitAt.clamp(0, rest.length));
      final part2 = rest.length > splitAt ? rest.substring(splitAt) : '';
      return part2.isEmpty ? '($ddd) $part1' : '($ddd) $part1-$part2';
    }, 11);
  }
}

String onlyDigits(String value) => value.replaceAll(RegExp(r'\D'), '');

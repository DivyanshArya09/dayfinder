class DateValidators {
  static String? validateDay(String? value) {
    if (value == null || value.isEmpty) return "Required";
    final day = int.tryParse(value);
    if (day == null || day < 1 || day > 31) return "Invalid day";
    return null;
  }

  static String? validateMonth(String? value) {
    if (value == null || value.isEmpty) return "Required";
    final month = int.tryParse(value);
    if (month == null || month < 1 || month > 12) return "Invalid month";
    return null;
  }

  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) return "Required";
    final year = int.tryParse(value);
    if (year == null || year < 1800) return "Year >= 1800";
    return null;
  }
}

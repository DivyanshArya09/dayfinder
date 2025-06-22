class Logic {
  static String calculateDay(
      {required int year, required int month, required int day}) {
    int m = month >= 3 ? month - 2 : month + 10;
    int y = year % 100;
    int c = year ~/ 100;
    int h = (day + ((13 * m - 1) ~/ 5) + y + y ~/ 4 + c ~/ 4 - 2 * c) % 7;

    return [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ][h];
  }
}

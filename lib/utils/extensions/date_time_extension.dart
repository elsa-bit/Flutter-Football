extension DateTimeExtension on DateTime {

  bool isEqualOrAfter(DateTime date) {
    return this.day >= date.day && this.month >= date.month && this.year >= date.year;
  }

  bool isBefore(DateTime date) {
    return this.year < date.year || this.month < date.month || this.day < date.day;
  }

  bool isEqualOrBefore(DateTime date) {
    return this.isEqual(date) || this.isBefore(date);
  }

  bool isEqual(DateTime date) {
    return this.day == date.day && this.month == date.month && this.year == date.year;
  }
}
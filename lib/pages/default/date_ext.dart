extension DateExt on DateTime {
  String date(){
    return "${this.year}-${this.month}-${this.day}";
  }
  bool isSameDateOrBefore(DateTime date) {
    return (this.year == date.year && this.day == date.day && this.month == date.month) || this.isBefore(date);
  }

  bool isSameDateOrAfter(DateTime date) {
    return (this.year == date.year && this.day == date.day && this.month == date.month) || this.isAfter(date);
  }
}
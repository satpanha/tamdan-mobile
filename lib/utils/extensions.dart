extension DateTimeExtensions on DateTime {
  String toShortDate() {
    final m = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    return "$day ${m[month - 1]} $year";
  }
}

extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

import 'package:intl/intl.dart';

/// Text/number/date formatting helpers used across the UI.
///
/// Keep this to generic, domain-agnostic formatting — anything specific to
/// a competition's SRS (e.g. currency for an e-commerce app) should be
/// added once that domain is known, not guessed at here.
class Formatters {
  const Formatters._();

  static final DateFormat _dateFormat = DateFormat('MMM d, yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('MMM d, yyyy • h:mm a');
  static final DateFormat _timeFormat = DateFormat('h:mm a');

  static String date(DateTime dateTime) => _dateFormat.format(dateTime);

  static String dateTime(DateTime dateTime) => _dateTimeFormat.format(dateTime);

  static String time(DateTime dateTime) => _timeFormat.format(dateTime);

  /// e.g. "3 hours ago", "Just now", "2 days ago".
  static String relativeTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return date(dateTime);
  }

  static String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  /// Title-cases each word, e.g. "john doe" -> "John Doe".
  static String titleCase(String value) {
    return value
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .map(capitalize)
        .join(' ');
  }

  /// Truncates with an ellipsis if [value] exceeds [maxLength].
  static String truncate(String value, int maxLength) {
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength).trimRight()}…';
  }

  /// Compact large numbers, e.g. 1200 -> "1.2K", 3400000 -> "3.4M".
  static String compactNumber(num value) {
    return NumberFormat.compact().format(value);
  }
}

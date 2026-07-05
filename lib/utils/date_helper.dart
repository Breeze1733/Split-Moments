import 'package:intl/intl.dart';

/// 日期格式化工具
class DateHelper {
  DateHelper._();

  /// 日期 → "YYYY-MM-DD"
  static String toDateStr(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// 今天的日期字符串
  static String get todayStr => toDateStr(DateTime.now());

  /// 日期 → "2026年07月05日 星期一"
  static String toChineseDate(DateTime date) {
    final weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    final formatted = DateFormat('yyyy年MM月dd日').format(date);
    final weekday = weekdays[date.weekday - 1];
    return '$formatted $weekday';
  }

  /// 判断两个日期是否是同一天
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// 判断是否是今天
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// 日期字符串转 DateTime
  static DateTime parseDateStr(String dateStr) {
    return DateFormat('yyyy-MM-dd').parse(dateStr);
  }

  /// 格式化时间戳为简短时间
  static String toShortTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}

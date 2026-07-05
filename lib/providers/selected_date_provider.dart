import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 当前选中的查看日期，默认今天
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

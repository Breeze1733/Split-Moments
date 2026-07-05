import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/moment.dart';
import '../utils/date_helper.dart';
import 'auth_provider.dart';
import 'selected_date_provider.dart';

/// 选定日期的双方动态（用于日视图分屏）
/// 返回 Map: { "myMoment": Moment?, "partnerMoment": Moment? }
final dayMomentsProvider = StreamProvider<Map<String, Moment?>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  final dateStr = DateHelper.toDateStr(selectedDate);
  final currentUser = ref.watch(currentUserProvider);
  final partner = ref.watch(partnerUserProvider);

  if (currentUser == null || partner == null) {
    return Stream.value({'myMoment': null, 'partnerMoment': null});
  }

  final firestoreService = ref.read(firestoreServiceProvider);

  return firestoreService
      .getDayMoments(dateStr, [currentUser.uid, partner.uid])
      .map((moments) {
    Moment? myMoment;
    Moment? partnerMoment;

    for (final m in moments) {
      if (m.authorId == currentUser.uid) {
        myMoment = m;
      } else if (m.authorId == partner.uid) {
        partnerMoment = m;
      }
    }

    return {'myMoment': myMoment, 'partnerMoment': partnerMoment};
  });
});

/// 当前用户有动态的日期列表（用于日历标记点）
final markedDatesProvider = FutureProvider<List<DateTime>>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) return [];

  final firestoreService = ref.read(firestoreServiceProvider);
  final dateStrs = await firestoreService.getDatesWithMoments(currentUser.uid);
  return dateStrs.map((s) => DateHelper.parseDateStr(s)).toList();
});

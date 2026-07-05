import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../models/moment.dart';

/// Firestore 数据库服务
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── 用户相关 ───

  /// 获取用户信息
  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromJson(doc.data()!);
  }

  /// 创建用户（首次使用时初始化）
  Future<void> createUser(AppUser user) async {
    await _db.collection('users').doc(user.uid).set(user.toJson());
  }

  /// 确保预设用户存在于 Firestore 中
  Future<void> ensurePresetUsers() async {
    for (final user in AppUser.presetUsers.values) {
      final existing = await getUser(user.uid);
      if (existing == null) {
        await createUser(user);
      }
    }
  }

  // ─── 动态相关 ───

  /// 获取指定日期指定用户的动态（Stream）
  Stream<Moment?> getMomentByDate(String userId, String dateStr) {
    return _db
        .collection('moments')
        .where('date_str', isEqualTo: dateStr)
        .where('author_id', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return Moment.fromFirestore(snapshot.docs.first);
    });
  }

  /// 获取指定日期的双方动态（Stream，用于日视图）
  Stream<List<Moment>> getDayMoments(String dateStr, List<String> authorIds) {
    if (authorIds.isEmpty) return Stream.value([]);
    return _db
        .collection('moments')
        .where('date_str', isEqualTo: dateStr)
        .where('author_id', whereIn: authorIds)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Moment.fromFirestore(doc)).toList();
    });
  }

  /// 获取指定日期指定用户的动态（Future，单次查询）
  Future<Moment?> getMomentByDateOnce(String userId, String dateStr) async {
    final snapshot = await _db
        .collection('moments')
        .where('date_str', isEqualTo: dateStr)
        .where('author_id', isEqualTo: userId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return Moment.fromFirestore(snapshot.docs.first);
  }

  /// 创建动态
  Future<String> createMoment({
    required String dateStr,
    required String authorId,
    required String selfImageUrl,
    required String partnerImageUrl,
    required String feeling,
  }) async {
    final docRef = await _db.collection('moments').add({
      'date_str': dateStr,
      'author_id': authorId,
      'self_image_url': selfImageUrl,
      'partner_image_url': partnerImageUrl,
      'feeling': feeling,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  /// 更新动态
  Future<void> updateMoment(String momentId, Map<String, dynamic> data) async {
    await _db.collection('moments').doc(momentId).update(data);
  }

  /// 获取某用户所有有动态的日期列表（用于日历标记）
  Future<List<String>> getDatesWithMoments(String userId) async {
    final snapshot = await _db
        .collection('moments')
        .where('author_id', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => (doc.data()['date_str'] as String?) ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }
}

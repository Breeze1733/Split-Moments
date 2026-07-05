import 'package:cloud_firestore/cloud_firestore.dart';

/// 动态数据模型（每天每条用户一条）
class Moment {
  final String id;
  final String dateStr; // YYYY-MM-DD
  final String authorId; // "A" 或 "B"
  final String selfImageUrl;
  final String partnerImageUrl;
  final String feeling;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Moment({
    required this.id,
    required this.dateStr,
    required this.authorId,
    required this.selfImageUrl,
    required this.partnerImageUrl,
    required this.feeling,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从 Firestore DocumentSnapshot 创建
  factory Moment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Moment(
      id: doc.id,
      dateStr: data['date_str'] as String? ?? '',
      authorId: data['author_id'] as String? ?? '',
      selfImageUrl: data['self_image_url'] as String? ?? '',
      partnerImageUrl: data['partner_image_url'] as String? ?? '',
      feeling: data['feeling'] as String? ?? '',
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// 转为 Firestore 文档数据
  Map<String, dynamic> toFirestore() {
    return {
      'date_str': dateStr,
      'author_id': authorId,
      'self_image_url': selfImageUrl,
      'partner_image_url': partnerImageUrl,
      'feeling': feeling,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
  }

  /// 更新用的数据（仅更新可变字段）
  Map<String, dynamic> toUpdateMap() {
    return {
      'self_image_url': selfImageUrl,
      'partner_image_url': partnerImageUrl,
      'feeling': feeling,
      'updated_at': FieldValue.serverTimestamp(),
    };
  }
}

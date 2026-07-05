import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/moment.dart';
import '../utils/date_helper.dart';
import 'avatar_widget.dart';

/// 朋友圈风格动态卡片
/// 展示：头像 + 昵称 + 自己的图 + 对方的图 + 感受文字 + 时间
class MomentCard extends StatelessWidget {
  final Moment moment;
  final String nickname;
  final String? avatarUrl;

  const MomentCard({
    super.key,
    required this.moment,
    this.nickname = '',
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppTheme.cardColor,
        border: Border(
          bottom: BorderSide(color: AppTheme.dividerColor, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像 + 昵称
          Row(
            children: [
              AvatarWidget(
                avatarUrl: avatarUrl,
                nickname: nickname,
                size: 32,
              ),
              const SizedBox(width: 8),
              Text(nickname, style: AppTheme.momentNickname),
            ],
          ),
          const SizedBox(height: 10),

          // 两张图片：左右并排
          Row(
            children: [
              Expanded(child: _buildImageBox(moment.selfImageUrl, '关于自己')),
              const SizedBox(width: 6),
              Expanded(child: _buildImageBox(moment.partnerImageUrl, '关于对方')),
            ],
          ),
          const SizedBox(height: 10),

          // 感受文字
          if (moment.feeling.isNotEmpty)
            Text(moment.feeling, style: AppTheme.momentContent),

          const SizedBox(height: 8),

          // 时间
          Text(
            DateHelper.toShortTime(moment.createdAt),
            style: AppTheme.momentTime,
          ),
        ],
      ),
    );
  }

  Widget _buildImageBox(String url, String label) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.antiAlias,
      child: url.isNotEmpty
          ? Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _placeholder(label),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black38,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ),
                ),
              ],
            )
          : _placeholder(label),
    );
  }

  Widget _placeholder(String label) {
    return Container(
      color: Colors.grey[100],
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.image_outlined, size: 28, color: Colors.grey[300]),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[400])),
        ],
      ),
    );
  }
}

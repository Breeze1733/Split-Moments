import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_theme.dart';
import '../constants/strings.dart';
import '../models/moment.dart';
import '../providers/auth_provider.dart';
import '../providers/day_moment_provider.dart';
import '../providers/selected_date_provider.dart';
import '../utils/date_helper.dart';
import '../widgets/calendar_picker.dart';
import '../widgets/date_header.dart';
import '../widgets/day_split_view.dart';
import 'edit_moment_screen.dart';

/// 主页面：顶栏 + 日视图分屏 + FAB
class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final currentUser = ref.watch(currentUserProvider);
    final partner = ref.watch(partnerUserProvider);

    // 确保用户数据已加载
    ref.watch(loadUsersProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        actions: [
          // 显示当前登录用户
          if (currentUser != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  avatar: const Icon(Icons.person, size: 16),
                  label: Text(currentUser.nickname),
                  backgroundColor: AppTheme.primaryColor.withAlpha(20),
                ),
              ),
            ),
          // 退出按钮
          IconButton(
            icon: const Icon(Icons.logout, size: 20),
            tooltip: AppStrings.logout,
            onPressed: () => _handleLogout(ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // 日期顶栏
          DateHeader(
            dateText: DateHelper.toChineseDate(selectedDate),
            onCalendarTap: () => _openCalendar(context, ref),
          ),

          // 分隔线
          const Divider(height: 1, thickness: 1, color: AppTheme.dividerColor),

          // 分屏日视图
          if (currentUser != null && partner != null) _buildDayView(ref, currentUser, partner),
        ],
      ),

      // FAB：仅今天显示
      floatingActionButton: DateHelper.isToday(selectedDate)
          ? _buildFab(context, ref, selectedDate, currentUser)
          : null,
    );
  }

  /// 构建日视图（消费 StreamProvider）
  Widget _buildDayView(WidgetRef ref, currentUser, partner) {
    final dayMomentsAsync = ref.watch(dayMomentsProvider);

    return dayMomentsAsync.when(
      data: (data) {
        final myMoment = data['myMoment'];
        final partnerMoment = data['partnerMoment'];
        return DaySplitView(
          myMoment: myMoment,
          partnerMoment: partnerMoment,
          myNickname: currentUser.nickname,
          partnerNickname: partner.nickname,
          myAvatarUrl: currentUser.avatarUrl,
          partnerAvatarUrl: partner.avatarUrl,
        );
      },
      loading: () => const Expanded(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Expanded(
        child: Center(child: Text('加载失败: $e')),
      ),
    );
  }

  /// FAB：根据今日是否已发布显示不同样式
  Widget _buildFab(BuildContext context, WidgetRef ref, DateTime selectedDate, currentUser) {
    final dayMomentsAsync = ref.watch(dayMomentsProvider);

    return dayMomentsAsync.when(
      data: (data) {
        final myMoment = data['myMoment'];
        final hasPosted = myMoment != null;

        return FloatingActionButton.extended(
          onPressed: () => _openEditor(context, ref, selectedDate, myMoment),
          icon: Icon(hasPosted ? Icons.edit : Icons.add),
          label: Text(hasPosted ? AppStrings.editTitle : AppStrings.createTitle),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  /// 打开日历选择器
  Future<void> _openCalendar(BuildContext context, WidgetRef ref) async {
    final markedDatesAsync = ref.read(markedDatesProvider);
    final markedDates = markedDatesAsync.valueOrNull ?? [];

    final picked = await CalendarPicker.show(
      context,
      selectedDate: ref.read(selectedDateProvider),
      markedDates: markedDates,
    );

    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = picked;
    }
  }

  /// 打开发布/编辑页
  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref,
    DateTime date,
    Moment? existingMoment,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditMomentScreen(
          date: date,
          existingMoment: existingMoment,
        ),
      ),
    );

    // 编辑/发布成功后刷新
    if (result == true) {
      // StreamProvider 会自动更新，但强制刷新确保一致
      ref.invalidate(dayMomentsProvider);
      ref.invalidate(markedDatesProvider);
    }
  }

  /// 退出登录
  void _handleLogout(WidgetRef ref) {
    final logout = ref.read(logoutActionProvider);
    logout();
    // 导航回登录页由 app.dart 的 auth 状态监听处理
  }
}

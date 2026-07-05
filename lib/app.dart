import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/feed_screen.dart';
import 'screens/login_screen.dart';

/// 应用根组件：根据认证状态切换页面
class SplitMomentsApp extends ConsumerWidget {
  const SplitMomentsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听自动登录状态
    final autoLoginAsync = ref.watch(autoLoginProvider);

    return MaterialApp(
      title: 'Split Moments',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: autoLoginAsync.when(
        data: (role) {
          // role != null 表示已登录，否则显示登录页
          if (role != null) {
            return const FeedScreen();
          }
          return const LoginScreen();
        },
        loading: () => const _SplashScreen(),
        error: (_, _) => const LoginScreen(),
      ),
    );
  }
}

/// 启动闪屏（检查登录状态时显示）
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 48, color: AppTheme.primaryColor),
            SizedBox(height: 16),
            Text(
              'Split Moments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }
}

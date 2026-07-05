import 'package:firebase_core/firebase_core.dart';

/// Firebase 配置选项
///
/// ⚠️ 使用前请先运行以下命令自动生成真实的配置：
///   dart pub global activate flutterfire_cli
///   flutterfire configure
///
/// 在此之前，请先在 Firebase Console (console.firebase.google.com) 创建一个项目。
///
/// 需要的 Firebase 服务：
/// - Firestore Database
/// - Storage（用于图片上传）
///
/// Firestore 安全规则（初始）：
///   rules_version = '2';
///   service cloud.firestore {
///     match /databases/{database}/documents {
///       match /users/{userId} {
///         allow read, write: if true;
///       }
///       match /moments/{momentId} {
///         allow read, write: if true;
///       }
///     }
///   }
///
/// Storage 安全规则（初始）：
///   rules_version = '2';
///   service firebase.storage {
///     match /b/{bucket}/o {
///       match /{allPaths=**} {
///         allow read, write: if true;
///       }
///     }
///   }

/// 默认 Firebase 选项
/// 请替换为 flutterfire configure 生成的实际值，
/// 或者直接修改下面的占位值
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'YOUR_API_KEY',
      appId: 'YOUR_APP_ID',
      messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
      projectId: 'YOUR_PROJECT_ID',
      authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
      storageBucket: 'YOUR_PROJECT_ID.appspot.com',
      iosBundleId: 'com.splitmoments.splitMoments',
    );
  }
}

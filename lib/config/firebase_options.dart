import 'package:firebase_core/firebase_core.dart';

/// Firebase 配置
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyD1teMmIWhVaU4xsqgqGlJBtu6ixoLdmHs',
      appId: '1:193237306549:web:1ed9c962ad24dac2ee82fc',
      messagingSenderId: '193237306549',
      projectId: 'split-moments',
      authDomain: 'split-moments.firebaseapp.com',
      storageBucket: 'split-moments.firebasestorage.app',
    );
  }
}

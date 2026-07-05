import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Firebase Storage 图片上传服务
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// 上传图片文件，返回下载 URL
  /// [file] 图片文件
  /// [folder] 存储路径前缀（如 "user_A"）
  Future<String> uploadImage(File file, String folder) async {
    final originalName = file.path.split('/').last;
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_$originalName';
    final ref = _storage.ref('$folder/$fileName');

    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  /// 删除图片（编辑时替换图片用）
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (_) {
      // 图片可能不存在，忽略错误
    }
  }
}

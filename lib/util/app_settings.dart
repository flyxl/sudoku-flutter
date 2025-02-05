import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AppSettings {
  static const String _imagePathsKey = 'background_image_paths';
  static const String _maxErrorsKey = 'max_errors';
  static String? _lastImagePath;

  // 获取最大错误次数
  static Future<int> getMaxErrors() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_maxErrorsKey) ?? 3; // 默认值为3
  }

  // 设置最大错误次数
  static Future<void> setMaxErrors(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_maxErrorsKey, count);
  }

  // 获取保存的图片路径列表
  static Future<List<String>> getImagePaths() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_imagePathsKey) ?? [];
  }

  // 随机获取一张用户设置的图片路径，确保和上次不一样
  static Future<String?> getRandomImage() async {
    final userImages = await getImagePaths();
    if (userImages.isEmpty) return null;
    if (userImages.length == 1) {
      _lastImagePath = userImages[0];
      return userImages[0];
    }

    final random = Random();
    String? newPath;
    do {
      newPath = userImages[random.nextInt(userImages.length)];
    } while (newPath == _lastImagePath && userImages.length > 1);

    _lastImagePath = newPath;
    return newPath;
  }

  // 保存图片路径列表
  static Future<void> saveImagePaths(List<String> paths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_imagePathsKey, paths);
  }

  // 选择并裁剪图片
  static Future<List<String>> pickAndCropImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images == null || images.isEmpty) return [];

    List<String> croppedPaths = [];
    for (var image in images) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 34, ratioY: 30),
        compressQuality: 100, // 保持100%质量
        compressFormat: ImageCompressFormat.png, // 使用PNG格式避免压缩损失
        maxWidth: 1020, // 增加最大宽度
        maxHeight: 900, // 增加最大高度
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '裁剪图片',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: '裁剪图片',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        croppedPaths.add(croppedFile.path);
      }
    }

    // 保存新的图片路径
    final existingPaths = await getImagePaths();
    existingPaths.addAll(croppedPaths);
    await saveImagePaths(existingPaths);

    return croppedPaths;
  }
}

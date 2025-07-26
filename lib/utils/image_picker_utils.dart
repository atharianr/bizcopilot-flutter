import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  static final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery with optional parameters
  static Future<File?> pickFromGallery({
    double? maxWidth = 800,
    double? maxHeight = 600,
    int? imageQuality = 85,
  }) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      rethrow;
    }
  }

  /// Take photo with camera with optional parameters
  static Future<File?> pickFromCamera({
    double? maxWidth = 800,
    double? maxHeight = 600,
    int? imageQuality = 85,
  }) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error taking photo with camera: $e');
      rethrow;
    }
  }

  /// Pick multiple images from gallery
  static Future<List<File>> pickMultipleImages({
    double? maxWidth = 800,
    double? maxHeight = 600,
    int? imageQuality = 85,
  }) async {
    try {
      final pickedFiles = await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      return pickedFiles.map((file) => File(file.path)).toList();
    } catch (e) {
      debugPrint('Error picking multiple images: $e');
      rethrow;
    }
  }

  /// Pick video from gallery or camera
  static Future<File?> pickVideo({
    required ImageSource source,
    Duration? maxDuration,
  }) async {
    try {
      final pickedFile = await _picker.pickVideo(
        source: source,
        maxDuration: maxDuration,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking video: $e');
      rethrow;
    }
  }

  /// Check if file is a valid image
  static bool isValidImageFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    const validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return validExtensions.contains(extension);
  }

  /// Get file size in MB
  static double getFileSizeInMB(File file) {
    final bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }

  /// Show error dialog for common image picker errors
  static void showImagePickerErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Picker Error'),
          content: Text(_getReadableErrorMessage(error)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Convert error messages to user-friendly text
  static String _getReadableErrorMessage(String error) {
    if (error.contains('permission')) {
      return 'Permission denied. Please allow camera and storage access in your device settings.';
    } else if (error.contains('camera')) {
      return 'Unable to access camera. Please check if another app is using the camera.';
    } else if (error.contains('gallery') || error.contains('photos')) {
      return 'Unable to access photo library. Please check permissions.';
    } else {
      return 'An error occurred while selecting the image. Please try again.';
    }
  }
}

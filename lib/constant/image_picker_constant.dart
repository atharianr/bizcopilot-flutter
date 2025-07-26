class ImagePickerConstants {
  // Image quality settings
  static const int defaultImageQuality = 85;
  static const int highImageQuality = 95;
  static const int lowImageQuality = 70;

  // Image dimensions
  static const double defaultMaxWidth = 800;
  static const double defaultMaxHeight = 600;
  static const double thumbnailMaxWidth = 300;
  static const double thumbnailMaxHeight = 300;
  static const double highResMaxWidth = 1200;
  static const double highResMaxHeight = 1200;

  // File size limits (in MB)
  static const double maxFileSizeMB = 5.0;
  static const double maxThumbnailSizeMB = 1.0;

  // Supported image formats
  static const List<String> supportedImageFormats = ['png'];

  // Error messages
  static const String permissionDenied =
      'Permission denied. Please allow camera and storage access.';
  static const String cameraNotAvailable =
      'Camera is not available on this device.';
  static const String galleryNotAvailable =
      'Gallery is not available on this device.';
  static const String fileSizeTooLarge =
      'File size is too large. Please select a smaller image.';
  static const String unsupportedFormat =
      'Unsupported image format. Please select a valid image.';
  static const String generalError =
      'An error occurred while selecting the image. Please try again.';

  // UI strings
  static const String selectImage = 'Select Image';
  static const String gallery = 'Gallery';
  static const String camera = 'Camera';
  static const String remove = 'Remove';
  static const String addProductImage = 'Add Product Image';
  static const String changeImage = 'Change Image';
  static const String noImageSelected = 'No image selected';

  // Animation durations
  static const Duration bottomSheetAnimationDuration = Duration(
    milliseconds: 300,
  );
  static const Duration imageLoadingDuration = Duration(milliseconds: 200);
}

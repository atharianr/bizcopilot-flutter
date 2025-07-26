import 'package:bizcopilot_flutter/data/model/response/upload_image_response.dart';

sealed class ImageUploadState {}

class ImageUploadNoneState extends ImageUploadState {}

class ImageUploadLoadingState extends ImageUploadState {}

class ImageUploadErrorState extends ImageUploadState {
  final String error;

  ImageUploadErrorState(this.error);
}

class ImageUploadLoadedState extends ImageUploadState {
  final UploadImageResponse? data;

  ImageUploadLoadedState(this.data);
}

import 'package:bizcopilot_flutter/data/model/response/upload_image_response.dart';

sealed class AwsUploadImageState {}

class AwsUploadImageNoneState extends AwsUploadImageState {}

class AwsUploadImageLoadingState extends AwsUploadImageState {}

class AwsUploadImageErrorState extends AwsUploadImageState {
  final String error;

  AwsUploadImageErrorState(this.error);
}

class AwsUploadImageLoadedState extends AwsUploadImageState {}

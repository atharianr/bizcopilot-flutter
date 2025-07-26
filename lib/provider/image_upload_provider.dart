import 'dart:io';

import 'package:bizcopilot_flutter/data/model/request/product_request_model.dart';
import 'package:bizcopilot_flutter/data/model/response/upload_image_response.dart';
import 'package:bizcopilot_flutter/static/state/aws_upload_image_state.dart';
import 'package:bizcopilot_flutter/static/state/image_upload_state.dart';
import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
import '../../data/model/request/product_request_model.dart';
import '../../static/state/add_product_result_state.dart';

class UploadImageProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  UploadImageProvider(this._apiServices);

  // Model
  File? _uploadImageFile;

  File? get uploadImageFile => _uploadImageFile;

  set setReportModel(File value) {
    _uploadImageFile = value;
    notifyListeners();
  }

  void resetImageFile() {
    _uploadImageFile = null;
    notifyListeners();
  }

  // Result State
  ImageUploadState? _resultState = ImageUploadNoneState();
  AwsUploadImageState _awsUploadImageState = AwsUploadImageNoneState();

  ImageUploadState? get resultState => _resultState;

  // Validation
  bool validateInputs() {
    bool isValid = true;

    if (_uploadImageFile == null) return false;
    return isValid;
  }

  // Submit
  Future<UploadImageResponse?> uploadImage() async {
    if (!validateInputs()) return null;

    try {
      _resultState = ImageUploadLoadingState();
      notifyListeners();

      final request = _uploadImageFile;

      var result = await _apiServices.imageUpload(imageFile: request!);

      _resultState = ImageUploadLoadedState(result);
      notifyListeners();
    } catch (e) {
      _resultState = ImageUploadErrorState(e.getMessage());
      notifyListeners();
    }
  }

  Future uploadImageToAWS(String path) async {
    try {
      _awsUploadImageState = AwsUploadImageLoadingState();
      notifyListeners();

      final request = _uploadImageFile;

      var result = await _apiServices.imageUploadToAWS(
        imageFile: request!,
        path: path,
      );

      _awsUploadImageState = AwsUploadImageLoadedState();
      notifyListeners();
    } catch (e) {
      _awsUploadImageState = AwsUploadImageErrorState(e.getMessage());
      notifyListeners();
    }
  }
}

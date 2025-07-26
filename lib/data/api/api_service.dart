import 'dart:io';

import 'package:bizcopilot_flutter/constant/constant.dart';
import 'package:bizcopilot_flutter/data/model/request/add_report_request.dart';
import 'package:bizcopilot_flutter/data/model/request/example_request.dart';
import 'package:bizcopilot_flutter/data/model/response/add_product_response.dart';
import 'package:bizcopilot_flutter/data/model/response/daily_reports_response.dart';
import 'package:bizcopilot_flutter/data/model/response/example_response.dart';
import 'package:bizcopilot_flutter/data/model/response/home_widgets_response.dart';
import 'package:bizcopilot_flutter/data/model/response/product_response.dart';
import 'package:bizcopilot_flutter/data/model/request/product_request_model.dart';
import 'package:bizcopilot_flutter/data/model/response/upload_image_response.dart';

import 'utils/base_network.dart';

class ApiServices {
  Future<HomeWidgetsResponse> getHomeWidgets() {
    final uri = Uri.parse("${Constant.baseUrl}/home-widgets");

    return BaseNetwork.get<HomeWidgetsResponse>(
      url: uri,
      headers: {"Content-Type": "application/json"},
      parser: (json) => HomeWidgetsResponse.fromJson(json),
    );
  }

  Future<DailyReportsResponse> getDailyReports() {
    final uri = Uri.parse("${Constant.baseUrl}/daily-reports");

    return BaseNetwork.get<DailyReportsResponse>(
      url: uri,
      headers: {"Content-Type": "application/json"},
      parser: (json) => DailyReportsResponse.fromJson(json),
    );
  }

  Future<ExampleResponse> addReport(AddReportRequest request) {
    final uri = Uri.parse("${Constant.baseUrl}/add-report");

    return BaseNetwork.post<ExampleResponse>(
      url: uri,
      headers: {"Content-Type": "application/json"},
      body: request.toJson(),
      parser: (json) => ExampleResponse.fromJson(json),
    );
  }

  Future addProduct(ProductRequestModel request) {
    final uri = Uri.parse("${Constant.baseUrl}/product/");

    return BaseNetwork.post<AddProductResponse>(
      url: uri,
      headers: {"Content-Type": "application/json"},
      body: request.toJson(),
      parser: (json) => AddProductResponse.fromJson(json),
      successCode: 200,
    );
  }

  Future<ExampleResponse> exampleApiHit(String id, String name, String review) {
    final request = ExampleRequest(id: id, name: name, review: review);
    final uri = Uri.parse("${Constant.baseUrl}/review");

    return BaseNetwork.post<ExampleResponse>(
      url: uri,
      headers: {"Content-Type": "application/json"},
      body: request.toJson(),
      parser: (json) => ExampleResponse.fromJson(json),
    );
  }

  /// Utils API
  Future<UploadImageResponse?> imageUpload({required File imageFile}) async {
    final uri = Uri.parse("${Constant.baseUrl}/upload-image/");
    return BaseNetwork.postImage<UploadImageResponse>(
      url: uri,
      headers: {
        "accept": "application/json",
        "Content-Type": "multipart/form-data",
      },
      file: imageFile,
      method: "POST",
      parser: (json) => UploadImageResponse.fromJson(json),
    );
  }

  Future<void> imageUploadToAWS({
    required File imageFile,
    required String path,
  }) async {
    final uri = Uri.parse(path);

    return BaseNetwork.postImage(
      url: uri,
      headers: {},
      file: imageFile,
      parser: (json) => null,
      method: "PUT",
    );
  }

  /// Products API
  Future<DataProductResponseModel> getAllProducts() {
    final uri = Uri.parse("${Constant.baseUrl}/product");

    return BaseNetwork.get<DataProductResponseModel>(
      url: uri,
      headers: {"Content-Type": "application/json"},
      parser: (json) => DataProductResponseModel.fromJson(json),
    );
  }
}

import 'package:bizcopilot_flutter/constant/constant.dart';
import 'package:bizcopilot_flutter/data/model/request/add_expense_report_request.dart';
import 'package:bizcopilot_flutter/data/model/request/add_sale_report_request.dart';
import 'package:bizcopilot_flutter/data/model/request/example_request.dart';
import 'package:bizcopilot_flutter/data/model/response/add_report_response.dart';
import 'package:bizcopilot_flutter/data/model/response/daily_reports_response.dart';
import 'package:bizcopilot_flutter/data/model/response/example_response.dart';
import 'package:bizcopilot_flutter/data/model/response/home_widgets_response.dart';
import 'package:bizcopilot_flutter/data/model/response/product_response.dart';
import 'package:bizcopilot_flutter/data/model/request/product_request_model.dart';

import 'utils/base_network.dart';

class ApiServices {
  Future<HomeWidgetsResponse> getHomeWidgets() {
    final uri = Uri.parse("${Constant.baseUrl}/home");

    return BaseNetwork.get<HomeWidgetsResponse>(
      url: uri,
      headers: {"Content-Type": "application/json"},
      parser: (json) => HomeWidgetsResponse.fromJson(json),
    );
  }

  Future<MonthlyReportsResponse> getDailyReports() {
    final uri = Uri.parse("${Constant.baseUrl}/report/monthly");

    return BaseNetwork.get<MonthlyReportsResponse>(
      url: uri,
      headers: {"Content-Type": "application/json"},
      parser: (json) => MonthlyReportsResponse.fromJson(json),
    );
  }

  Future<AddReportResponse> addSaleReport(AddSaleReportRequest request) {
    final uri = Uri.parse("${Constant.baseUrl}/sale");
    final response = BaseNetwork.post<AddReportResponse>(
      url: uri,
      headers: {"Content-Type": "application/json"},
      body: request.toJson(),
      parser: (json) => AddReportResponse.fromJson(json),
    );
    return response;
  }

  Future<AddReportResponse> addExpenseReport(AddExpenseReportRequest request) {
    final uri = Uri.parse("${Constant.baseUrl}/expense");
    final response = BaseNetwork.post<AddReportResponse>(
      url: uri,
      headers: {"Content-Type": "application/json"},
      body: request.toJson(),
      parser: (json) => AddReportResponse.fromJson(json),
    );
    return response;
  }

  Future<ExampleResponse> addProduct(ProductRequestModel request) {
    final uri = Uri.parse("${Constant.baseUrl}/product/");

    return BaseNetwork.post<ExampleResponse>(
      url: uri,
      headers: {"Content-Type": "application/json"},
      body: request.toJson(),
      parser: (json) => ExampleResponse.fromJson(json),
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

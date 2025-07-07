import 'package:bizcopilot_flutter/data/model/response/product_response.dart';
import 'package:bizcopilot_flutter/static/reports/report_type.dart';

class AddReportModel {
  String? name;
  String? description;
  int? price;
  Products? product;
  String? date;
  ReportType type;

  AddReportModel({
    this.name,
    this.description,
    this.price,
    this.product,
    this.date,
    this.type = ReportType.sales,
  });
}

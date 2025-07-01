import 'package:bizcopilot_flutter/static/reports/report_type.dart';

class AddReportModel {
  String? name;
  String? description;
  int? price;
  String? date;
  ReportType? tag;

  AddReportModel({
    this.name,
    this.description,
    this.price,
    this.date,
    this.tag,
  });
}

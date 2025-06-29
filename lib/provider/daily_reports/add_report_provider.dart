import 'package:bizcopilot_flutter/data/model/add_report_model.dart';
import 'package:flutter/widgets.dart';

class AddReportProvider extends ChangeNotifier {
  AddReportModel? _addReportModel;

  AddReportModel? get addReportModel => _addReportModel;

  set setReportModel(AddReportModel value) {
    _addReportModel = value;
    notifyListeners();
  }
}

import 'package:bizcopilot_flutter/data/model/add_report_model.dart';
import 'package:bizcopilot_flutter/data/model/request/add_report_request.dart';
import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
import '../../static/state/add_report_result_state.dart';

class AddReportProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  AddReportModel? _addReportModel;

  AddReportModel? get addReportModel => _addReportModel;

  set setReportModel(AddReportModel value) {
    _addReportModel = value;
    notifyListeners();
  }

  AddReportProvider(this._apiServices);

  AddReportResultState _resultState = AddReportNoneState();

  AddReportResultState get resultState => _resultState;

  Future<void> addReport() async {
    try {
      _resultState = AddReportLoadingState();
      notifyListeners();

      final request = AddReportRequest(
        typeId: addReportModel?.type.id,
        reportName: addReportModel?.name,
        reportDescription: addReportModel?.description,
        price: addReportModel?.price,
        date: addReportModel?.date,
        productId: 0,
        quantity: 0,
      );
      final result = await _apiServices.addReport(request);
      _resultState = AddReportLoadedState(true);
      notifyListeners();
    } catch (e) {
      _resultState = AddReportErrorState(e.getMessage());
      notifyListeners();
    }
  }
}

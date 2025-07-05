import 'package:bizcopilot_flutter/data/model/add_report_model.dart';
import 'package:bizcopilot_flutter/static/reports/report_type.dart';
import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
import '../../data/model/request/add_sale_report_request.dart';
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

      if (_addReportModel?.type == ReportType.sales) {
        final request = AddSaleReportRequest(
          productId: 1,
          userId: 1,
          quantity: 1,
          saleDate: _addReportModel?.date,
        );
        final result = await _apiServices.addSaleReport(request);
        _resultState = AddReportLoadedState(true);
        notifyListeners();
      } else {

      }
    } catch (e) {
      _resultState = AddReportErrorState(e.getMessage());
      notifyListeners();
    }
  }
}

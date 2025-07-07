import 'package:bizcopilot_flutter/data/model/add_report_model.dart';
import 'package:bizcopilot_flutter/data/model/request/add_expense_report_request.dart';
import 'package:bizcopilot_flutter/static/reports/report_type.dart';
import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
import '../../data/model/request/add_sale_report_request.dart';
import '../../static/state/add_report_result_state.dart';

class AddReportProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  AddReportProvider(this._apiServices);

  // Model
  AddReportModel? _addReportModel;

  AddReportModel? get addReportModel => _addReportModel;

  set setReportModel(AddReportModel value) {
    _addReportModel = value;
    notifyListeners();
  }

  void resetSaleReportModel() {
    _addReportModel = AddReportModel(
      name: null,
      description: null,
      price: null,
      product: null,
      date: _addReportModel?.date,
      type: ReportType.sales,
    );
    notifyListeners();
  }

  void resetExpenseReportModel() {
    _addReportModel = AddReportModel(
      name: null,
      description: null,
      price: null,
      product: null,
      date: _addReportModel?.date,
      type: ReportType.expenses,
    );
    notifyListeners();
  }

  void resetReportModel() {
    _addReportModel = AddReportModel();
    notifyListeners();
  }

  // Errors
  String? _nameError;
  String? _descriptionError;
  String? _priceError;
  String? _productError;
  String? _dateError;

  String? get nameError => _nameError;

  String? get descriptionError => _descriptionError;

  String? get priceError => _priceError;

  String? get productError => _productError;

  String? get dateError => _dateError;

  // Result State
  AddReportResultState _resultState = AddReportNoneState();

  AddReportResultState get resultState => _resultState;

  // Error Helpers
  void _setError({
    String? name,
    String? description,
    String? price,
    String? product,
    String? date,
  }) {
    _nameError = name;
    _descriptionError = description;
    _priceError = price;
    _productError = product;
    _dateError = date;
    notifyListeners();
  }

  void resetErrors() {
    _setError();
  }

  // Validation
  bool validateInputs() {
    bool isValid = true;
    resetErrors();

    if (_addReportModel == null) return false;

    if (_addReportModel!.type == ReportType.sales) {
      if (_addReportModel!.name == null || _addReportModel!.name!.isEmpty) {
        _setError(product: "Please select a product");
        isValid = false;
      }
    } else {
      String? nameErr, descErr, priceErr;

      if (_addReportModel!.name == null || _addReportModel!.name!.isEmpty) {
        nameErr = "Name is required";
        isValid = false;
      }
      if (_addReportModel!.description == null ||
          _addReportModel!.description!.isEmpty) {
        descErr = "Description is required";
        isValid = false;
      }
      if (_addReportModel!.price == null || _addReportModel!.price! <= 0) {
        priceErr = "Price is required";
        isValid = false;
      }

      _setError(name: nameErr, description: descErr, price: priceErr);
    }

    if (_addReportModel!.date == null || _addReportModel!.date!.isEmpty) {
      _setError(date: "Date is required");
      isValid = false;
    }

    return isValid;
  }

  // Submit
  Future<void> addReport() async {
    if (!validateInputs()) return;

    try {
      _resultState = AddReportLoadingState();
      notifyListeners();

      if (_addReportModel!.type == ReportType.sales) {
        final request = AddSaleReportRequest(
          productId: _addReportModel?.product?.id,
          userId: _addReportModel?.product?.userId ?? 1,
          quantity: 1, // for removing stock by 1
          saleDate: _addReportModel?.date,
        );
        await _apiServices.addSaleReport(request);
      } else {
        final request = AddExpenseReportRequest(
          userId: _addReportModel?.product?.userId ?? 1,
          amount: _addReportModel?.price,
          title: _addReportModel?.name,
          description: _addReportModel?.description,
          expenseDate: _addReportModel?.date,
        );
        await _apiServices.addExpenseReport(request);
      }

      _resultState = AddReportLoadedState(true);
    } catch (e) {
      _resultState = AddReportErrorState(e.getMessage());
    }

    notifyListeners();
  }
}

import 'package:bizcopilot_flutter/data/model/request/product_request_model.dart';
import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
import '../../data/model/request/product_request_model.dart';
import '../../static/state/add_product_result_state.dart';

class AddProductProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  AddProductProvider(this._apiServices);

  // Model
  ProductRequestModel? _addReportModel;

  ProductRequestModel? get addReportModel => _addReportModel;

  set setReportModel(ProductRequestModel value) {
    _addReportModel = value;
    notifyListeners();
  }

  void resetSaleReportModel() {
    _addReportModel = ProductRequestModel(
      name: null,
      description: null,
      inventory: null,
      price: null,
      costPrice: null,
      userId: _addReportModel?.userId,
    );
    notifyListeners();
  }

  void resetExpenseReportModel() {
     _addReportModel = ProductRequestModel(
      name: null,
      description: null,
      inventory: null,
      price: null,
      costPrice: null,
      userId: _addReportModel?.userId,
    );
    notifyListeners();
  }

  void resetReportModel() {
    _addReportModel = ProductRequestModel();
    notifyListeners();
  }

  // Errors
  String? _nameError;
  String? _descriptionError;
  String? _priceError;
  String? _stockError;
  String? _costPriceError;

  String? get nameError => _nameError;

  String? get descriptionError => _descriptionError;

  String? get priceError => _priceError;

  String? get stockError => _stockError;

  String? get costPriceError => _costPriceError;

  // Result State
  AddProductResultState _resultState = AddProductNoneState();

  AddProductResultState get resultState => _resultState;

  // Error Helpers
  void _setError({
    String? name,
    String? description,
    String? price,
    String? stock,
    String? costPrice,
  }) {
    _nameError = name;
    _descriptionError = description;
    _priceError = price;
    _stockError = stock;
    _costPriceError = costPrice;
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

    String? nameErr, descErr, priceErr, stockErr, costPriceErr;

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

    if (_addReportModel!.costPrice == null || _addReportModel!.costPrice! <= 0) {
      costPriceErr = "Cost price is required";
      isValid = false;
    }

    if (_addReportModel!.inventory == null || _addReportModel!.inventory! <= 0) {
      stockErr = "Stock is required";
      isValid = false;
    }

    _setError(
      name: nameErr,
      description: descErr,
      price: priceErr,
      stock: stockErr,
      costPrice: costPriceErr,
    );

    return isValid;
  }

  // Submit
  Future<void> addProduct() async {
    if (!validateInputs()) return;

    try {
      _resultState = AddProductLoadingState();
      notifyListeners();

      final request = ProductRequestModel(
        userId: _addReportModel?.userId ?? 1,
        name: _addReportModel?.name,
        description: _addReportModel?.description,
        inventory: _addReportModel?.inventory,
        price: _addReportModel?.price,
        costPrice: _addReportModel?.costPrice,
      );

      await _apiServices.addProduct(request);

      _resultState = AddProductLoadedState(true);
    } catch (e) {
      _resultState = AddProductErrorState(e.getMessage());
    }

    notifyListeners();
  }
}

import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
import '../../static/state/list_product_result_state.dart';

class ListProductProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  ListProductProvider(this._apiServices);

  ListProductResultState _resultState = ListProductNoneState();

  ListProductResultState get resultState => _resultState;

  Future<void> getAllListProducts() async {
    try {
      _resultState = ListProductLoadingState();
      notifyListeners();

      final result = await _apiServices.getAllProducts();
      _resultState = ListProductLoadedState(
        result.data?.getAllProducts?.products ?? [],
      );
      notifyListeners();
    } catch (e) {
      _resultState = ListProductErrorState(e.getMessage());
      notifyListeners();
    }
  }
}

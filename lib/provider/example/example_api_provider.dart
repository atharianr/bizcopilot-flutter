import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
import '../../static/state/example_api_result_state.dart';

class ExampleApiProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  ExampleApiProvider(this._apiServices);

  ExampleApiResultState _resultState = ExampleApiNoneState();

  ExampleApiResultState get resultState => _resultState;

  String _restaurantId = "";

  String get restaurantId => _restaurantId;

  set restaurantId(String value) {
    _restaurantId = value;
    notifyListeners();
  }

  bool _isSubmitted = false;

  bool get isSubmitted => _isSubmitted;

  set isSubmitted(bool value) {
    _isSubmitted = value;
    notifyListeners();
  }

  void resetState() {
    _resultState = ExampleApiNoneState();
  }

  Future<void> addRestaurantReview(
    String id,
    String name,
    String review,
  ) async {
    try {
      _restaurantId = "";
      _isSubmitted = false;
      _resultState = ExampleApiLoadingState();
      notifyListeners();
      final result = await _apiServices.exampleApiHit(id, name, review);
      if (result.error) {
        _resultState = ExampleApiErrorState(result.message);
        notifyListeners();
      } else {
        _restaurantId = id;
        _isSubmitted = true;
        _resultState = ExampleApiLoadedState(result.message);
        notifyListeners();
      }
    } catch (e) {
      _resultState = ExampleApiErrorState(e.getMessage());
      notifyListeners();
    }
  }
}

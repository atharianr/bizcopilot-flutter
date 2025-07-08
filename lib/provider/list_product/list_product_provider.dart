import 'package:bizcopilot_flutter/screen/list_product/list_product.dart';
import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
import '../../static/state/list_product_result_state.dart';
import '../../data/model/response/product_response.dart';

import '../../extension/List+Extensions.dart';

class ListProductProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  ListProductProvider(this._apiServices);

  ListProductResultState _resultState = ListProductNoneState();

  ListProductResultState get resultState => _resultState;

  List<Products> unsortedAllProducts = [];
  List<Products> sortedAllProducts = [];

  Future<void> getAllListProducts() async {
    try {
      _resultState = ListProductLoadingState();
      notifyListeners();

      final result = await _apiServices.getAllProducts();
      unsortedAllProducts = result.data?.getAllProducts?.products ?? [];
      sortedAllProducts = unsortedAllProducts;
      _resultState = ListProductLoadedState(sortedAllProducts);
      notifyListeners();
    } catch (e) {
      _resultState = ListProductErrorState(e.getMessage());
      notifyListeners();
    }
  }

  void sortProducts({
    SortingType type = SortingType.nothing, 
    SortingOrder order = SortingOrder.ascending
  }) {
      switch (type) {
        case SortingType.nothing:
          sortedAllProducts = unsortedAllProducts;
          break;
        case SortingType.name:
          sortedAllProducts = unsortedAllProducts.sortedBy((product) => product.name ?? "");
          break;
        case SortingType.price:
          sortedAllProducts = unsortedAllProducts.sortedBy((product) => product.price ?? 0.0);
          break;
        case SortingType.time:
          sortedAllProducts = unsortedAllProducts.sortedBy((product) => product.updatedAt ?? product.createdAt ?? "");
          break;
        case SortingType.stock:
          sortedAllProducts = unsortedAllProducts.sortedBy((product) => product.inventory ?? 0);
      }
    _resultState = ListProductLoadedState(sortedAllProducts);
    notifyListeners();
  }
}

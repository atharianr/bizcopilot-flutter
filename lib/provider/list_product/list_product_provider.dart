// import 'package:bizcopilot_flutter/utils/extension_utils.dart';
// import 'package:flutter/widgets.dart';

// import '../../data/api/api_service.dart';
// import '../../static/state/daily_reports_result_state.dart';

// class ListProductProvider extends ChangeNotifier {
//   final ApiServices _apiServices;

//   ListProductProvider(this._apiServices);

//   ListProductProvider _resultState = ListProductProvider();

//   ListProductProvider get resultState => _resultState;

//   Future<void> getAllProducts() async {
//     try {
//       _resultState = ListProductProvider();
//       notifyListeners();

//       final result = await _apiServices.getDailyReports();
//       _resultState = ListProductProvider(
//         result.data?.getDailyReports?.dailyReports ?? [],
//       );
//       notifyListeners();
//     } catch (e) {
//       _resultState = ListProductProvider(e.getMessage());
//       notifyListeners();
//     }
//   }
// }

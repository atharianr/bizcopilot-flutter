import 'package:bizcopilot_flutter/data/model/response/product_response.dart';
import 'package:bizcopilot_flutter/provider/daily_reports/add_report_provider.dart';
import 'package:bizcopilot_flutter/provider/daily_reports/daily_reports_provider.dart';
import 'package:bizcopilot_flutter/provider/daily_reports/home_widgets_provider.dart';
import 'package:bizcopilot_flutter/provider/example/example_api_provider.dart';
import 'package:bizcopilot_flutter/provider/forecast/forecast_provider.dart';
import 'package:bizcopilot_flutter/provider/list_product/add_product_provider.dart';
import 'package:bizcopilot_flutter/provider/list_product/list_product_provider.dart';
import 'package:bizcopilot_flutter/provider/main/index_nav_provider.dart';
import 'package:bizcopilot_flutter/screen/add_product/add_product_screen.dart';
import 'package:bizcopilot_flutter/screen/edit_product/edit_product_screen.dart';
import 'package:bizcopilot_flutter/screen/forecast/forecast_screen.dart';
import 'package:bizcopilot_flutter/screen/main/main_screen.dart';
import 'package:bizcopilot_flutter/screen/reports/reports_screen.dart';
import 'package:bizcopilot_flutter/static/navigation/navigation_route.dart';
import 'package:bizcopilot_flutter/style/theme/biz_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/api/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => ApiServices()),
        ChangeNotifierProvider(create: (context) => IndexNavProvider()),
        ChangeNotifierProvider(
          create: (context) => AddReportProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => DailyReportsProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeWidgetsProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ListProductProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ExampleApiProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AddProductProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ForecastProvider(context.read<ApiServices>()),
        ),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Biz-CoPilot",
      theme: BizTheme.lightTheme,
      darkTheme: BizTheme.lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: NavigationRoute.mainRoute.name,
      routes: {
        NavigationRoute.mainRoute.name: (context) => const MainScreen(),
        NavigationRoute.forecastRoute.name: (context) => const ForecastScreen(),
        NavigationRoute.reportsRoute.name: (context) => const ReportsScreen(),
        NavigationRoute.addProductRoute.name:
            (context) => const AddProductScreen(),
        NavigationRoute.editProductRoute.name: (context) {
          final product =
              ModalRoute.of(context)!.settings.arguments as Products;
          return EditProductScreen(product: product);
        },
        // NavigationRoute.detailRoute.name:
        //     (context) => DetailScreen(
        //       restaurantId:
        //           ModalRoute.of(context)?.settings.arguments as String,
        //     ),
      },
    );
  }
}

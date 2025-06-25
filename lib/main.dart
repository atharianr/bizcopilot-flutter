import 'package:bizcopilot_flutter/provider/daily_reports/daily_reports_provider.dart';
import 'package:bizcopilot_flutter/provider/example/example_api_provider.dart';
import 'package:bizcopilot_flutter/provider/main/index_nav_provider.dart';
import 'package:bizcopilot_flutter/screen/main/main_screen.dart';
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
          create:
              (context) => DailyReportsProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ExampleApiProvider(context.read<ApiServices>()),
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
        // NavigationRoute.detailRoute.name:
        //     (context) => DetailScreen(
        //       restaurantId:
        //           ModalRoute.of(context)?.settings.arguments as String,
        //     ),
      },
    );
  }
}

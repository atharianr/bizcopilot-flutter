import 'package:bizcopilot_flutter/screen/forecast/forecast_screen.dart';
import 'package:bizcopilot_flutter/screen/home/home_screen.dart';
import 'package:bizcopilot_flutter/screen/reports/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data/model/add_report_model.dart';
import '../../provider/daily_reports/add_report_provider.dart';
import '../../provider/main/index_nav_provider.dart';
import '../../static/bottom_nav/bottom_nav.dart';
import '../../style/color/biz_colors.dart';
import '../widget/reports/add_report_bottom_sheet.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Consumer<IndexNavProvider>(
          builder: (context, value, child) {
            return switch (value.indexBottomNavBar) {
              _ when value.indexBottomNavBar == BottomNav.home.index =>
                const HomeScreen(),
              _ when value.indexBottomNavBar == BottomNav.forecast.index =>
                const ForecastScreen(),
              _ when value.indexBottomNavBar == BottomNav.reports.index =>
                const ReportsScreen(),
              _ when value.indexBottomNavBar == BottomNav.products.index =>
                const HomeScreen(),
              _ => const HomeScreen(),
            };
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 16,
              offset: const Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: BizColors.colorBackground.getColor(context),
          currentIndex: context.watch<IndexNavProvider>().indexBottomNavBar,
          onTap: (index) {
            if (index == BottomNav.add.index) {
              final provider = context.read<AddReportProvider>();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                // barrierColor: Colors.transparent,
                builder: (context) => const AddReportBottomSheet(),
              ).then((_) {
                provider.setReportModel = AddReportModel();
              });
            } else {
              context.read<IndexNavProvider>().setIndexBottomNavBar = index;
            }
          },
          selectedItemColor: Colors.transparent,
          unselectedItemColor: Colors.transparent,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          showUnselectedLabels: false,
          items: _getBottomNavBarItems(context),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _getBottomNavBarItems(BuildContext context) {
    return [
      BottomNavigationBarItem(
        icon: _buildIcon(
          context,
          BottomNav.home,
          'assets/images/ic_nav_home_black_32.svg',
        ),
        label: "Home",
        tooltip: "Home",
      ),
      BottomNavigationBarItem(
        icon: _buildIcon(
          context,
          BottomNav.forecast,
          'assets/images/ic_nav_forecast_black_32.svg',
        ),
        label: "Forecast",
        tooltip: "Forecast",
      ),
      BottomNavigationBarItem(
        icon: _buildIcon(
          context,
          BottomNav.add,
          'assets/images/ic_nav_add_black_36.svg',
        ),
        label: "Add Reports",
        tooltip: "Add Reports",
      ),
      BottomNavigationBarItem(
        icon: _buildIcon(
          context,
          BottomNav.reports,
          'assets/images/ic_nav_reports_black_32.svg',
        ),
        label: "Reports",
        tooltip: "Reports",
      ),
      BottomNavigationBarItem(
        icon: _buildIcon(
          context,
          BottomNav.products,
          'assets/images/ic_nav_list_black_32.svg',
        ),
        label: "Products",
        tooltip: "Products",
      ),
    ];
  }

  Widget _buildIcon(BuildContext context, BottomNav navItem, String iconPath) {
    final isSelected =
        context.watch<IndexNavProvider>().indexBottomNavBar == navItem.index;

    if (isSelected || navItem == BottomNav.add) {
      return ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [
              BizColors.colorPrimary.getColor(context),
              BizColors.colorPrimaryDark.getColor(context),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          width: 32,
          height: 32,
        ),
      );
    } else {
      return SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(
          BizColors.colorGrey.getColor(context),
          BlendMode.srcIn,
        ),
        width: 32,
        height: 32,
      );
    }
  }
}

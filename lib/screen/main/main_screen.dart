import 'package:bizcopilot_flutter/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../provider/main/index_nav_provider.dart';
import '../../static/bottom_nav/bottom_nav.dart';
import '../../style/color/biz_colors.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexNavProvider>(
        builder: (context, value, child) {
          return switch (value.indexBottomNavBar) {
            _ when value.indexBottomNavBar == BottomNav.home.index =>
              const HomeScreen(),
            _ when value.indexBottomNavBar == BottomNav.forecast.index =>
              const HomeScreen(),
            _ when value.indexBottomNavBar == BottomNav.add.index =>
              const HomeScreen(),
            _ when value.indexBottomNavBar == BottomNav.reports.index =>
              const HomeScreen(),
            _ when value.indexBottomNavBar == BottomNav.products.index =>
              const HomeScreen(),
            _ => const HomeScreen(),
          };
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
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
            context.read<IndexNavProvider>().setIndexBottomNavBar = index;
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

  // ignore: unused_element
  Widget _buildIcon(BuildContext context, BottomNav navItem, String iconPath) {
    final isSelected =
        context.watch<IndexNavProvider>().indexBottomNavBar == navItem.index;

    return _buildSvgIcon(
      context,
      iconPath,
      isSelected || navItem == BottomNav.add,
    );
  }

  Widget _buildSvgIcon(
    BuildContext context,
    String assetName,
    bool isSelected,
  ) {
    final color =
        isSelected
            ? BizColors.colorPrimary.getColor(context)
            : BizColors.colorGrey.getColor(context);
    return SvgPicture.asset(
      assetName,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      width: 32,
      height: 32,
    );
  }
}

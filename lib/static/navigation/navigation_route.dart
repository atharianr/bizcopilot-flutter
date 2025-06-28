enum NavigationRoute {
  mainRoute("/"),
  forecastRoute("/forecast"),
  reportsRoute("/reports"),
  detailRoute("/detail");

  const NavigationRoute(this.name);

  final String name;
}

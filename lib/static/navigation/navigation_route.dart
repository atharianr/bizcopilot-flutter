enum NavigationRoute {
  mainRoute("/"),
  forecastRoute("/forecast"),
  reportsRoute("/reports"),
  detailRoute("/detail"),
  addProductRoute("/add-product-route");

  const NavigationRoute(this.name);

  final String name;
}

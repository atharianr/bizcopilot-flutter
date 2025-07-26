enum NavigationRoute {
  mainRoute("/"),
  forecastRoute("/forecast"),
  reportsRoute("/reports"),
  detailRoute("/detail"),
  addProductRoute("/add-product-route"),
  editProductRoute("/edit-product-route");

  const NavigationRoute(this.name);

  final String name;
}

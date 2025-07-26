class AddSaleReportRequest {
  int? productId;
  int? userId;
  int? quantity;
  String? saleDate;

  AddSaleReportRequest({
    this.productId,
    this.userId,
    this.quantity,
    this.saleDate,
  });

  factory AddSaleReportRequest.fromJson(Map<String, dynamic> json) =>
      AddSaleReportRequest(
        productId: json["product_id"],
        userId: json["user_id"],
        quantity: json["quantity"],
        saleDate: json["sale_date"],
      );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "user_id": userId,
    "quantity": quantity,
    "sale_date": saleDate,
  };
}

class AddReportRequest {
  int? typeId;
  String? reportName;
  String? reportDescription;
  int? price;
  String? date;
  int? productId;
  int? quantity;

  AddReportRequest({
    this.typeId,
    this.reportName,
    this.reportDescription,
    this.price,
    this.date,
    this.productId,
    this.quantity,
  });

  factory AddReportRequest.fromJson(Map<String, dynamic> json) =>
      AddReportRequest(
        typeId: json["type_id"],
        reportName: json["report_name"],
        reportDescription: json["report_description"],
        price: json["price"],
        date: json["date"],
        productId: json["product_id"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
    "type_id": typeId,
    "report_name": reportName,
    "report_description": reportDescription,
    "price": price,
    "date": date,
    "product_id": productId,
    "quantity": quantity,
  };
}

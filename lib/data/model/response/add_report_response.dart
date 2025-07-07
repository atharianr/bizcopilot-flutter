class AddReportResponse {
  Data? data;

  AddReportResponse({this.data});

  factory AddReportResponse.fromJson(Map<String, dynamic> json) =>
      AddReportResponse(
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  CreateSale? createSale;

  Data({this.createSale});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    createSale:
        json["createSale"] != null
            ? CreateSale.fromJson(json["createSale"])
            : null,
  );

  Map<String, dynamic> toJson() => {"createSale": createSale?.toJson()};
}

class CreateSale {
  Sale? sale;

  CreateSale({this.sale});

  factory CreateSale.fromJson(Map<String, dynamic> json) => CreateSale(
    sale: json["sale"] != null ? Sale.fromJson(json["sale"]) : null,
  );

  Map<String, dynamic> toJson() => {"sale": sale?.toJson()};
}

class Sale {
  int? saleId;
  String? message;

  Sale({this.saleId, this.message});

  factory Sale.fromJson(Map<String, dynamic> json) =>
      Sale(saleId: json["sale_id"], message: json["message"]);

  Map<String, dynamic> toJson() => {"sale_id": saleId, "message": message};
}

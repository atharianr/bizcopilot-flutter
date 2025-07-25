class AddReportResponse {
  Data? data;

  AddReportResponse({this.data});

  AddReportResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  GetSalesReport? getSalesReport;

  Data({this.getSalesReport});

  Data.fromJson(Map<String, dynamic> json) {
    getSalesReport =
        json['getSalesReport'] != null
            ? GetSalesReport.fromJson(json['getSalesReport'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getSalesReport != null) {
      data['getSalesReport'] = getSalesReport!.toJson();
    }
    return data;
  }
}

class GetSalesReport {
  List<SalesReport>? salesReport;

  GetSalesReport({this.salesReport});

  GetSalesReport.fromJson(Map<String, dynamic> json) {
    if (json['salesReport'] != null) {
      salesReport = <SalesReport>[];
      json['salesReport'].forEach((v) {
        salesReport!.add(SalesReport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (salesReport != null) {
      data['salesReport'] = salesReport!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesReport {
  int? id;
  String? saleDate;
  String? productName;
  int? productId;
  String? productDescription;
  int? productUnitPrice;
  int? quantity;
  int? totalSaleAmount;

  SalesReport({
    this.id,
    this.saleDate,
    this.productName,
    this.productId,
    this.productDescription,
    this.productUnitPrice,
    this.quantity,
    this.totalSaleAmount,
  });

  SalesReport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    saleDate = json['sale_date'];
    productName = json['product_name'];
    productId = json['product_id'];
    productDescription = json['product_description'];
    productUnitPrice = json['product_unit_price'];
    quantity = json['quantity'];
    totalSaleAmount = json['total_sale_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sale_date'] = saleDate;
    data['product_name'] = productName;
    data['product_id'] = productId;
    data['product_description'] = productDescription;
    data['product_unit_price'] = productUnitPrice;
    data['quantity'] = quantity;
    data['total_sale_amount'] = totalSaleAmount;
    return data;
  }
}

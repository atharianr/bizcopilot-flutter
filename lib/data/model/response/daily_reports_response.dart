class MonthlyReportsResponse {
  Data? data;

  MonthlyReportsResponse({this.data});

  MonthlyReportsResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (data != null) {
      json['data'] = data!.toJson();
    }
    return json;
  }
}

class Data {
  GetMonthlyReports? getMonthlyReports;

  Data({this.getMonthlyReports});

  Data.fromJson(Map<String, dynamic> json) {
    getMonthlyReports =
        json['getMonthlyReports'] != null
            ? GetMonthlyReports.fromJson(json['getMonthlyReports'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (getMonthlyReports != null) {
      json['getMonthlyReports'] = getMonthlyReports!.toJson();
    }
    return json;
  }
}

class GetMonthlyReports {
  List<Reports>? reports;

  GetMonthlyReports({this.reports});

  GetMonthlyReports.fromJson(Map<String, dynamic> json) {
    if (json['reports'] != null) {
      reports = <Reports>[];
      json['reports'].forEach((v) {
        reports!.add(Reports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (reports != null) {
      json['reports'] = reports!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class Reports {
  int? id;
  int? productId;
  String? name;
  String? description;
  String? transactionType;
  String? value;
  String? createdAt;
  String? currency;

  Reports({
    this.id,
    this.productId,
    this.name,
    this.description,
    this.transactionType,
    this.value,
    this.createdAt,
    this.currency,
  });

  Reports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    name = json['name'];
    description = json['description'];
    transactionType = json['transaction_type'];
    value = json['value'];
    createdAt = json['created_at'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['product_id'] = productId;
    json['name'] = name;
    json['description'] = description;
    json['transaction_type'] = transactionType;
    json['value'] = value;
    json['created_at'] = createdAt;
    json['currency'] = currency;
    return json;
  }
}

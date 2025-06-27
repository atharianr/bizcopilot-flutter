class DailyReportsResponse {
  Data? data;

  DailyReportsResponse({this.data});

  DailyReportsResponse.fromJson(Map<String, dynamic> json) {
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
  GetDailyReports? getDailyReports;

  Data({this.getDailyReports});

  Data.fromJson(Map<String, dynamic> json) {
    getDailyReports =
        json['getDailyReports'] != null
            ? GetDailyReports.fromJson(json['getDailyReports'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getDailyReports != null) {
      data['getDailyReports'] = getDailyReports!.toJson();
    }
    return data;
  }
}

class GetDailyReports {
  List<DailyReports>? dailyReports;

  GetDailyReports({this.dailyReports});

  GetDailyReports.fromJson(Map<String, dynamic> json) {
    if (json['dailyReports'] != null) {
      dailyReports = <DailyReports>[];
      json['dailyReports'].forEach((v) {
        dailyReports!.add(DailyReports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dailyReports != null) {
      data['dailyReports'] = dailyReports!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyReports {
  String? createdAt;
  String? currency;
  String? description;
  int? id;
  String? name;
  String? transactionType;
  int? transactionTypeId;
  String? value;

  DailyReports({
    this.createdAt,
    this.currency,
    this.description,
    this.id,
    this.name,
    this.transactionType,
    this.transactionTypeId,
    this.value,
  });

  DailyReports.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    currency = json['currency'];
    description = json['description'];
    id = json['id'];
    name = json['name'];
    transactionType = json['transactionType'];
    transactionTypeId = json['transactionTypeId'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['currency'] = currency;
    data['description'] = description;
    data['id'] = id;
    data['name'] = name;
    data['transactionType'] = transactionType;
    data['transactionTypeId'] = transactionTypeId;
    data['value'] = value;
    return data;
  }
}

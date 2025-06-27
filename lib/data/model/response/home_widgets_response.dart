class HomeWidgetsResponse {
  Data? data;

  HomeWidgetsResponse({this.data});

  HomeWidgetsResponse.fromJson(Map<String, dynamic> json) {
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
  GetHomeWidget? getHomeWidget;

  Data({this.getHomeWidget});

  Data.fromJson(Map<String, dynamic> json) {
    getHomeWidget =
        json['getHomeWidget'] != null
            ? GetHomeWidget.fromJson(json['getHomeWidget'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getHomeWidget != null) {
      data['getHomeWidget'] = getHomeWidget!.toJson();
    }
    return data;
  }
}

class GetHomeWidget {
  List<Widgets>? widgets;

  GetHomeWidget({this.widgets});

  GetHomeWidget.fromJson(Map<String, dynamic> json) {
    if (json['widgets'] != null) {
      widgets = <Widgets>[];
      json['widgets'].forEach((v) {
        widgets!.add(Widgets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (widgets != null) {
      data['widgets'] = widgets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Widgets {
  String? createdAt;
  String? currency;
  String? forecast;
  int? id;
  String? name;
  int? value;
  bool? withForecast;

  Widgets({
    this.createdAt,
    this.currency,
    this.forecast,
    this.id,
    this.name,
    this.value,
    this.withForecast,
  });

  Widgets.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    currency = json['currency'];
    forecast = json['forecast'];
    id = json['id'];
    name = json['name'];
    value = json['value'];
    withForecast = json['withForecast'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['currency'] = currency;
    data['forecast'] = forecast;
    data['id'] = id;
    data['name'] = name;
    data['value'] = value;
    data['withForecast'] = withForecast;
    return data;
  }
}

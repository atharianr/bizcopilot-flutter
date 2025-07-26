class HomeWidgetsResponse {
  Data? data;

  HomeWidgetsResponse({this.data});

  HomeWidgetsResponse.fromJson(Map<String, dynamic> json) {
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
  GetHomeWidgets? getHomeWidgets;

  Data({this.getHomeWidgets});

  Data.fromJson(Map<String, dynamic> json) {
    getHomeWidgets =
        json['getHomeWidgets'] != null
            ? GetHomeWidgets.fromJson(json['getHomeWidgets'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (getHomeWidgets != null) {
      json['getHomeWidgets'] = getHomeWidgets!.toJson();
    }
    return json;
  }
}

class GetHomeWidgets {
  List<Widgets>? widgets;

  GetHomeWidgets({this.widgets});

  GetHomeWidgets.fromJson(Map<String, dynamic> json) {
    if (json['widgets'] != null) {
      widgets = <Widgets>[];
      json['widgets'].forEach((v) {
        widgets!.add(Widgets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (widgets != null) {
      json['widgets'] = widgets!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class Widgets {
  String? name;
  int? value;

  Widgets({this.name, this.value});

  Widgets.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['name'] = name;
    json['value'] = value;
    return json;
  }
}

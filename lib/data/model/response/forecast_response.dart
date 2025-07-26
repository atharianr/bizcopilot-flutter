class ForecastResponse {
  MonthlyData? monthlyData;

  ForecastResponse({this.monthlyData});

  ForecastResponse.fromJson(Map<String, dynamic> json) {
    monthlyData =
        json['monthly_data'] != null
            ? MonthlyData.fromJson(json['monthly_data'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (monthlyData != null) {
      data['monthly_data'] = monthlyData!.toJson();
    }
    return data;
  }
}

class MonthlyData {
  List<SalesData>? salesData;
  List<ForecastData>? forecastData;
  AnalysisResult? analysisResult;

  MonthlyData({this.salesData, this.forecastData, this.analysisResult});

  MonthlyData.fromJson(Map<String, dynamic> json) {
    if (json['sales_data'] != null) {
      salesData = <SalesData>[];
      json['sales_data'].forEach((v) {
        salesData!.add(SalesData.fromJson(v));
      });
    }
    if (json['forecast_data'] != null) {
      forecastData = <ForecastData>[];
      json['forecast_data'].forEach((v) {
        forecastData!.add(ForecastData.fromJson(v));
      });
    }
    analysisResult =
        json['analysis_result'] != null
            ? AnalysisResult.fromJson(json['analysis_result'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (salesData != null) {
      data['sales_data'] = salesData!.map((v) => v.toJson()).toList();
    }
    if (forecastData != null) {
      data['forecast_data'] = forecastData!.map((v) => v.toJson()).toList();
    }
    if (analysisResult != null) {
      data['analysis_result'] = analysisResult!.toJson();
    }
    return data;
  }
}

class SalesData {
  String? x;
  double? y;

  SalesData({this.x, this.y});

  SalesData.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;
    return data;
  }
}

class ForecastData {
  String? x;
  double? yhat;
  double? yhatLower;
  double? yhatUpper;

  ForecastData({this.x, this.yhat, this.yhatLower, this.yhatUpper});

  ForecastData.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    yhat = json['yhat'];
    yhatLower = json['yhat_lower'];
    yhatUpper = json['yhat_upper'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['yhat'] = yhat;
    data['yhat_lower'] = yhatLower;
    data['yhat_upper'] = yhatUpper;
    return data;
  }
}

class AnalysisResult {
  String? summary;
  List<String>? recommendations;
  String? narrative;

  AnalysisResult({this.summary, this.recommendations, this.narrative});

  AnalysisResult.fromJson(Map<String, dynamic> json) {
    summary = json['summary'];
    recommendations = json['recommendations'].cast<String>();
    narrative = json['narrative'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['summary'] = summary;
    data['recommendations'] = recommendations;
    data['narrative'] = narrative;
    return data;
  }
}

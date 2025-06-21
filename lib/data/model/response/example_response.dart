

class ExampleResponse {
  bool error;
  String message;
  int count;
  int founded;

  ExampleResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.founded,
  });

  factory ExampleResponse.fromJson(Map<String, dynamic> json) =>
      ExampleResponse(
        error: json["error"],
        message: json["message"] ?? "",
        count: json["count"] ?? 0,
        founded: json["founded"] ?? 0,
      );
}

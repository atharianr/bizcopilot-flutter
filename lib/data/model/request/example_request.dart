class ExampleRequest {
  String? id;
  String? name;
  String? review;

  ExampleRequest({this.id, this.name, this.review});

  factory ExampleRequest.fromJson(Map<String, dynamic> json) => ExampleRequest(
    id: json["id"],
    name: json["name"],
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "review": review};
}

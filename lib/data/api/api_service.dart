import 'package:bizcopilot_flutter/constant/constant.dart';
import 'package:bizcopilot_flutter/data/model/request/example_request.dart';
import 'package:bizcopilot_flutter/data/model/response/example_response.dart';

import 'utils/base_network.dart';

class ApiServices {
  Future<ExampleResponse> exampleApiHit(
    String id,
    String name,
    String review,
  ) {
    final request = ExampleRequest(id: id, name: name, review: review);
    final uri = Uri.parse("${Constant.baseUrl}/review");

    return BaseNetwork.post<ExampleResponse>(
      url: uri,
      headers: {"Content-Type": "application/json"},
      body: request.toJson(),
      parser: (json) => ExampleResponse.fromJson(json),
    );
  }
}

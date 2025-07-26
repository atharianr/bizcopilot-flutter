import 'package:bizcopilot_flutter/data/model/response/product_response.dart';

sealed class ListProductResultState {}

class ListProductNoneState extends ListProductResultState {}

class ListProductLoadingState extends ListProductResultState {}

class ListProductErrorState extends ListProductResultState {
  final String error;

  ListProductErrorState(this.error);
}

class ListProductLoadedState extends ListProductResultState {
  final List<Products> data;

  ListProductLoadedState(this.data);
}

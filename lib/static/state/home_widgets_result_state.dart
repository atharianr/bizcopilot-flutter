import 'package:bizcopilot_flutter/data/model/response/home_widgets_response.dart';

sealed class HomeWidgetsResultState {}

class HomeWidgetsNoneState extends HomeWidgetsResultState {}

class HomeWidgetsLoadingState extends HomeWidgetsResultState {}

class HomeWidgetsErrorState extends HomeWidgetsResultState {
  final String error;

  HomeWidgetsErrorState(this.error);
}

class HomeWidgetsLoadedState extends HomeWidgetsResultState {
  final List<Widgets> data;

  HomeWidgetsLoadedState(this.data);
}

sealed class AddReportResultState {}

class AddReportNoneState extends AddReportResultState {}

class AddReportLoadingState extends AddReportResultState {}

class AddReportErrorState extends AddReportResultState {
  final String error;

  AddReportErrorState(this.error);
}

class AddReportLoadedState extends AddReportResultState {
  final bool data;

  AddReportLoadedState(this.data);
}

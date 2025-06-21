sealed class ExampleApiResultState {}

class ExampleApiNoneState extends ExampleApiResultState {}

class ExampleApiLoadingState extends ExampleApiResultState {}

class ExampleApiErrorState extends ExampleApiResultState {
  final String error;

  ExampleApiErrorState(this.error);
}

class ExampleApiLoadedState extends ExampleApiResultState {
  final String data;

  ExampleApiLoadedState(this.data);
}

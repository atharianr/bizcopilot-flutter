sealed class AddProductResultState {}

class AddProductNoneState extends AddProductResultState {}

class AddProductLoadingState extends AddProductResultState {}

class AddProductErrorState extends AddProductResultState {
  final String error;

  AddProductErrorState(this.error);
}

class AddProductLoadedState extends AddProductResultState {
  final bool data;

  AddProductLoadedState(this.data);
}

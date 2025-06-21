extension ExceptionMessageExtension on Object {
  String getMessage() {
    return toString().replaceFirst('Exception: ', '');
  }
}

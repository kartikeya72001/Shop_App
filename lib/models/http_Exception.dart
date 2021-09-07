class HttpExepction implements Exception {
  final String message;
  HttpExepction(this.message);

  @override
  String toString() {
    return message;
  }
}

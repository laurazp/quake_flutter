/// Mirrors Quake/NetworkClient/NetworkClientError.swift.
sealed class NetworkClientError implements Exception {
  const NetworkClientError();
}

class BadUrlError extends NetworkClientError {
  const BadUrlError();

  @override
  String toString() => 'The request URL was invalid.';
}

class InvalidResponseError extends NetworkClientError {
  final int? statusCode;
  const InvalidResponseError({this.statusCode});

  @override
  String toString() =>
      'The server returned an invalid response${statusCode != null ? ' ($statusCode)' : ''}.';
}

class DecodingError extends NetworkClientError {
  final Object cause;
  const DecodingError(this.cause);

  @override
  String toString() => 'Could not read the earthquake data ($cause).';
}

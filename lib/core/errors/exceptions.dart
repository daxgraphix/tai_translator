/// Low-level exceptions thrown by data sources. These are caught by
/// repository implementations and converted into [Failure]s.
class OfflineDataException implements Exception {
  final String message;
  OfflineDataException([this.message = 'No offline match found.']);
}

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error.']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error.']);
}

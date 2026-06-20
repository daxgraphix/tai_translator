/// Base failure type returned by repositories instead of throwing,
/// so the presentation layer can handle errors declaratively.
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class OfflineDataFailure extends Failure {
  const OfflineDataFailure([super.message = 'No offline data available for this request.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection available.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'The translation service returned an error.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage operation failed.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong.']);
}

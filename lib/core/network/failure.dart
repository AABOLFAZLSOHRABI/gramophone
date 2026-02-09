abstract class Failure {
  final String message;
  const Failure(this.message);
}
class NetworkFailure extends Failure{
  NetworkFailure([super.message = "Network error occurred"]);
  
}
class TimeoutFailure extends Failure{
  TimeoutFailure([super.message = "Timeout error occurred"]);
  
}
class ServerFailure extends Failure{
  ServerFailure([super.message = "Server error occurred"]);
  
}
class UnknownFailure extends Failure{
  UnknownFailure([super.message = "An unspecified error occurred."]);
  
}
import 'package:ethic_fin_todo_assessment/exports.dart';

abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = AppStrings.serverError]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = AppStrings.cacheError]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = AppStrings.networkError]);
}

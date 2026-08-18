import 'package:ethic_fin_todo_assessment/exports.dart';

class ServerException implements Exception {
  final String message;

  const ServerException([this.message = AppStrings.serverError]);
}

class CacheException implements Exception {
  final String message;

  const CacheException([this.message = AppStrings.cacheError]);
}

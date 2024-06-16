class ExceptionsFactory {
  static final ExceptionsFactory _singleton = ExceptionsFactory._internal();

  factory ExceptionsFactory() {
    return _singleton;
  }
  ExceptionsFactory._internal();

  Exception handleStatusCode(int statusCode,  {String? errorMessage}) {
    switch (statusCode) {
      case 400:
        return Exception(errorMessage ?? 'Bad request.');
      case 401:
        return Exception(errorMessage ?? 'Authentication failed.');
      case 403:
        return Exception(errorMessage ?? 'The authenticated user is not allowed to access the specified API endpoint.');
      case 404:
        return Exception(errorMessage ?? 'The requested resource does not exist.');
      case 405:
        return Exception(errorMessage ?? 'Method not allowed. Please check the Allow header for the allowed HTTP methods.');
      case 415:
        return Exception(errorMessage ?? 'Unsupported media type. The requested content type or version number is invalid.');
      case 422:
        return Exception(errorMessage ?? 'Data validation failed.');
      case 429:
        return Exception(errorMessage ?? 'Too many requests.');
      case 500:
        return Exception(errorMessage ?? 'Internal server error.');
      default:
        return Exception(errorMessage ?? 'Oops something went wrong!');
    }
  }
}
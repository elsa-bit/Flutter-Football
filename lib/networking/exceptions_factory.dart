class ExceptionsFactory {
  static final ExceptionsFactory _singleton = ExceptionsFactory._internal();

  factory ExceptionsFactory() {
    return _singleton;
  }
  ExceptionsFactory._internal();

  Exception handleStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return Exception('Bad request.');
      case 401:
        return Exception('Authentication failed.');
      case 403:
        return Exception('The authenticated user is not allowed to access the specified API endpoint.');
      case 404:
        return Exception('The requested resource does not exist.');
      case 405:
        return Exception('Method not allowed. Please check the Allow header for the allowed HTTP methods.');
      case 415:
        return Exception('Unsupported media type. The requested content type or version number is invalid.');
      case 422:
        return Exception('Data validation failed.');
      case 429:
        return Exception('Too many requests.');
      case 500:
        return Exception('Internal server error.');
      default:
        return Exception('Oops something went wrong!');
    }
  }
}
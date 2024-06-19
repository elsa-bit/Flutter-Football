
enum MediaStatus {
  initial,
  loading,
  success,
  error
}

class MediaState {
  final MediaStatus status;
  final MediaResponse? response;
  final String? error;

  MediaState({
    this.status = MediaStatus.initial,
    this.response,
    this.error,
  });

  MediaState copyWith({
    MediaStatus? status,
    MediaResponse? response,
    String? error,
  }) {
    return MediaState(
      status: status ?? this.status,
      response: response, //?? this.response,
      error: error ?? this.error,
    );
  }
}

class MediaResponse {
  final String url;
  final String identifier;

  MediaResponse({required this.url, required this.identifier});
}
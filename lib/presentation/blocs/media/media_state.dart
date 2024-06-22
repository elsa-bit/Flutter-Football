enum MediaStatus { initial, loading, success, error }

class MediaState {
  final MediaStatus status;
  final MediaResponse? response;
  final List<Video>? videos;
  final String? error;

  MediaState({
    this.status = MediaStatus.initial,
    this.response,
    this.videos = const [],
    this.error = '',
  });

  MediaState copyWith({
    MediaStatus? status,
    MediaResponse? response,
    List<Video>? videos,
    String? error,
  }) {
    return MediaState(
      status: status ?? this.status,
      response: response, //?? this.response,
      videos: videos ?? this.videos,
      error: error ?? this.error,
    );
  }
}

class MediaResponse {
  final String url;
  final String? identifier;

  MediaResponse({required this.url, this.identifier});
}

class Video {
  final String url;
  final String name;

  Video({required this.url, required this.name});
}

enum MediaStatus { initial, loading, success, profileUpdated, error }

class MediaState {
  final MediaStatus status;
  final MediaResponse? response;
  final List<Video>? videosGeneral;
  final List<Video>? videosPhysical;
  final List<Video>? videosSpecific;
  final String? error;

  MediaState({
    this.status = MediaStatus.initial,
    this.response,
    this.videosGeneral = const [],
    this.videosPhysical = const [],
    this.videosSpecific = const [],
    this.error = '',
  });

  MediaState copyWith({
    MediaStatus? status,
    MediaResponse? response,
    List<Video>? videosGeneral,
    List<Video>? videosPhysical,
    List<Video>? videosSpecific,
    String? error,
  }) {
    return MediaState(
      status: status ?? this.status,
      response: response, //?? this.response,
      videosGeneral: videosGeneral ?? this.videosGeneral,
      videosPhysical: videosPhysical ?? this.videosPhysical,
      videosSpecific: videosSpecific ?? this.videosSpecific,
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

  factory Video.fromJson(Map<String, dynamic> json) {
    try {
      final String url = json["url"] as String;
      final String name = json["name"] as String;

      return Video(
        url: url,
        name: name,
      );
    } catch (e) {
      print(e);
      throw const FormatException('Failed to convert Video data.');
    }
  }
}

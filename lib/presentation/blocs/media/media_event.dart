abstract class MediaEvent {}

class GetAvatar extends MediaEvent {
  final String identifier;
  final String? imageName;

  GetAvatar({
    required this.identifier,
    required this.imageName,
  });
}

class GetClubRule extends MediaEvent {
  GetClubRule();
}

class GetVideosBucket extends MediaEvent {
  final String bucketName;

  GetVideosBucket({required this.bucketName});
}

class GetSpecificVideos extends MediaEvent {
  GetSpecificVideos();
}

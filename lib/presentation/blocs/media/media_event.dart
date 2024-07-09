import 'dart:io';

abstract class MediaEvent {}

class GetAvatar extends MediaEvent {
  final String identifier;

  GetAvatar({
    required this.identifier,
  });
}

class GetUserAvatar extends MediaEvent {
  final String identifier;
  final String userID;

  GetUserAvatar({
    required this.identifier,
    required this.userID,
  });
}

class GetClubRule extends MediaEvent {
  GetClubRule();
}

class GetVideosBucket extends MediaEvent {
  final String bucketName;

  GetVideosBucket({required this.bucketName});
}

class UpdateProfilePicture extends MediaEvent {
  final File imageFile;

  UpdateProfilePicture(this.imageFile);
}

class GetSpecificVideos extends MediaEvent {
  GetSpecificVideos();
}

class ClearMediaState extends MediaEvent {
  ClearMediaState();
}


abstract class MediaEvent {}

class GetAvatar extends MediaEvent {
  final String identifier;
  final String? imageName;

  GetAvatar({
    required this.identifier,
    required this.imageName,
  });
}

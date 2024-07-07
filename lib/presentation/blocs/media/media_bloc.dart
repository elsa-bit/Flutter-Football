import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/media_repository.dart';
import 'package:flutter_football/presentation/blocs/media/media_event.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final MediaRepository repository;

  MediaBloc({required this.repository}) : super(MediaState()) {
    on<GetAvatar>((event, emit) async {
      try {
        emit(state.copyWith(status: MediaStatus.loading));
        if (event.imageName != null && event.imageName!.isNotEmpty) {
          final url = await repository.getAvatar(event.imageName!);
          print(url);
          emit(state.copyWith(
              response: MediaResponse(url: url, identifier: event.identifier),
              status: MediaStatus.success));
        } else {
          final url = await repository.getDefaultAvatar();
          print(url);
          emit(state.copyWith(
              response: MediaResponse(url: url, identifier: event.identifier),
              status: MediaStatus.success));
        }
      } catch (error) {
        emit(state.copyWith(
            error: error.toString(),
            status: MediaStatus.error,
            response: null));
      }
    });

    on<GetClubRule>((event, emit) async {
      try {
        emit(state.copyWith(status: MediaStatus.loading));
        final url = await repository.getClubRule();
        emit(state.copyWith(
            response: MediaResponse(url: url), status: MediaStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(
            error: errorMessage, status: MediaStatus.error, response: null));
      }
    });

    on<GetVideosBucket>((event, emit) async {
      try {
        emit(state.copyWith(status: MediaStatus.loading));
        final videos = await repository.getVideosBucket(event.bucketName);

        if (event.bucketName == 'trainingGeneral') {
          emit(state.copyWith(
              videosGeneral: videos, status: MediaStatus.success));
        } else if (event.bucketName == 'trainingPhysical') {
          emit(state.copyWith(
              videosPhysical: videos, status: MediaStatus.success));
        }
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(error: errorMessage, status: MediaStatus.error));
      }
    });

    on<GetSpecificVideos>((event, emit) async {
      try {
        emit(state.copyWith(status: MediaStatus.loading));
        final videos = await repository.getSpecificVideos();
        emit(state.copyWith(
            videosSpecific: videos, status: MediaStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(
            error: errorMessage, status: MediaStatus.error, response: null));
      }
    });

    on<ClearMediaState>((event, emit) async {
      emit(MediaState());
    });
  }
}

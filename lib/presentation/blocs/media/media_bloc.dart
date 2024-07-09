import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/media_repository.dart';
import 'package:flutter_football/presentation/blocs/media/media_event.dart';
import 'package:flutter_football/presentation/blocs/media/media_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final MediaRepository repository;

  MediaBloc({required this.repository}) : super(MediaState()) {
    on<GetAvatar>((event, emit) async {
      try {
        emit(state.copyWith(status: MediaStatus.loading));
        String? urlAvatar = await repository.getAvatar();
        if (urlAvatar == null) {
          urlAvatar = await repository.getDefaultAvatar();
        }

        print(urlAvatar);
        emit(state.copyWith(
            response: MediaResponse(url: urlAvatar, identifier: event.identifier),
            status: MediaStatus.success));
      } on StorageException catch(error) {
        final urlAvatar = await repository.getDefaultAvatar();
        print(urlAvatar);
        emit(state.copyWith(
            response: MediaResponse(url: urlAvatar, identifier: event.identifier),
            status: MediaStatus.success));
      } catch (error) {
        emit(state.copyWith(
            error: error.toString(),
            status: MediaStatus.error,
            response: null));
      }
    });

    on<GetUserAvatar>((event, emit) async {
      try {
        emit(state.copyWith(status: MediaStatus.loading));
        String urlAvatar = await repository.getUserAvatar(event.userID);
        print(urlAvatar);
        emit(state.copyWith(
            response: MediaResponse(url: urlAvatar, identifier: event.identifier),
            status: MediaStatus.success));
      } on StorageException catch(error) {
        final urlAvatar = await repository.getDefaultAvatar();
        print(urlAvatar);
        emit(state.copyWith(
            response: MediaResponse(url: urlAvatar, identifier: event.identifier),
            status: MediaStatus.success));
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
        emit(state.copyWith(
            error: error.toString(),
            status: MediaStatus.error,
            response: null));
      }
    });

    on<GetVideosBucket>((event, emit) async {
      try {
        emit(state.copyWith(status: MediaStatus.loading));
        final videos = await repository.getVideosBucket(event.bucketName);

        if(event.bucketName == 'trainingGeneral'){
          emit(state.copyWith(videosGeneral: videos, status: MediaStatus.success));
        }else if(event.bucketName == 'trainingPhysical'){
          emit(state.copyWith(videosPhysical: videos, status: MediaStatus.success));
        }
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: MediaStatus.error,
        ));
      }
    });

    on<GetSpecificVideos>((event, emit) async {
      try {
        emit(state.copyWith(status: MediaStatus.loading));
        final videos = await repository.getSpecificVideos();
        emit(state.copyWith(videosSpecific: videos, status: MediaStatus.success));
      } catch (error) {
        emit(state.copyWith(
            error: error.toString(),
            status: MediaStatus.error,
            response: null));
      }
    });

    on<UpdateProfilePicture>((event, emit) async {
      try {
        emit(state.copyWith(status: MediaStatus.loading));
        await repository.updateProfilePicture(event.imageFile);
        emit(state.copyWith(status: MediaStatus.profileUpdated));
      } catch (error) {
        emit(state.copyWith(
            error: error.toString(),
            status: MediaStatus.error,
            response: null));
      }
    });

    on<ClearMediaState>((event, emit) async {
      emit(MediaState());
    });
  }
}

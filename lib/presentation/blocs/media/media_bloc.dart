import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/media_repository.dart';
import 'package:flutter_football/main.dart';
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
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(
            error: errorMessage, status: MediaStatus.error, response: null));
      }
    });

    on<GetCoachRule>((event, emit) async {
      try {
        emit(state.copyWith(status: MediaStatus.loading));
        final url = await repository.getCoachRule();
        emit(state.copyWith(
            response: MediaResponse(url: url), status: MediaStatus.success));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(
            error: errorMessage, status: MediaStatus.error, response: null));
      }
    });

    on<GetDocumentClub>((event, emit) async {
      try {
        emit(state.copyWith(status: MediaStatus.loading));
        final url = await repository.getDocumentClub();
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

    on<GetMatchBucketImages>((event, emit) async {
      try {
        emit(state.copyWith(status: MediaStatus.loadingImages));
        final images = await repository.getMatchBucketImages(event.matchId);
        emit(state.copyWith(status: MediaStatus.success, images: images));
      } catch (error) {
        final errorMessage = error.toString().replaceFirst('Exception: ', '');
        emit(state.copyWith(status: MediaStatus.success, images: []));

      }
    });

    on<AddImageToMatchBucket>((event, emit) async {
      try {
        final String url = await supabase.storage.from('match-resources')
            .createSignedUrl(event.fileName, 7200); // 7200 secondes = 2 hours
        List<String> gallery = state.images ?? [];
        gallery.add(url);
        emit(state.copyWith(status: MediaStatus.success, images: gallery));
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

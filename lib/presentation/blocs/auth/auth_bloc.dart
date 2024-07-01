import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/auth_repository.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthState()) {

    on<IsUserAuthenticated>((event, emit) async {
      try {
        //emit(state.copyWith(status: AuthStatus.loading));
        final isAuthenticated = await repository.isUserAuthenticated();
        final user = repository.user;

        if(!isAuthenticated || user == null) {
          emit(state.copyWith(status: AuthStatus.unauthenticated, user: repository.user));
          return;
        }

        if (user.userMetadata?["role"] == "coach") {
          emit(state.copyWith(status: AuthStatus.authenticatedAsCoach, user: repository.user));
        } else if (user.userMetadata?["role"] == "player") {
          emit(state.copyWith(status: AuthStatus.authenticatedAsPlayer, user: repository.user));
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated, user: repository.user));
        }
      } on AuthException catch (error) {
        emit(state.copyWith(error: error.toString(), status: AuthStatus.unauthenticated, user: null));
      } catch (error) {
        emit(state.copyWith(error: error.toString(), status: AuthStatus.error,));
      }
    });

    on<AuthenticateUser>((event, emit) async {
      //emit(state.copyWith(status: AuthStatus.loading));
      final user = event.auth.user;

      if(user == null) {
        emit(state.copyWith(status: AuthStatus.unauthenticated, user: repository.user));
        return;
      }

      if (user.userMetadata?["role"] == "coach") {
        await repository.authenticateUser(event.auth);
        emit(state.copyWith(status: AuthStatus.authenticatedAsCoach, user: repository.user));
      } else if (user.userMetadata?["role"] == "player") {
        final int? idPlayer = user.userMetadata?["idPlayer"] as int?;

        if (idPlayer != null) {
          final bool hasAccess = await repository.playerHasAccess(idPlayer);
          if (hasAccess) {
            await repository.authenticateUser(event.auth);
            emit(state.copyWith(status: AuthStatus.authenticatedAsPlayer, user: repository.user));
          } else {
            emit(state.copyWith(status: AuthStatus.playerAccessForbidden, user: null));
          }
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated, user: repository.user));
        }
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated, user: repository.user));
      }
    });

    on<AuthenticateUserWithToken>((event, emit) async {
      //repository.authenticateUser(event.auth);
      //emit(state.copyWith(status: AuthStatus.authenticated));
    });

    on<Logout>((event, emit) async {
      repository.logout();
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
    });

  }
}
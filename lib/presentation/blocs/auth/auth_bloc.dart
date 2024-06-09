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
        emit(state.copyWith(status: AuthStatus.loading));
        final isAuthenticated = await repository.isUserAuthenticated();
        emit(state.copyWith(status: isAuthenticated ? AuthStatus.authenticated : AuthStatus.unauthenticated, user: repository.user));
      } on AuthException catch (error) {
        emit(state.copyWith(error: error.toString(), status: AuthStatus.unauthenticated, user: null));
      } catch (error) {
        emit(state.copyWith(error: error.toString(), status: AuthStatus.error,));
      }
    });

    on<AuthenticateUser>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      await repository.authenticateUser(event.auth);
      emit(state.copyWith(status: AuthStatus.authenticated, user: repository.user));
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
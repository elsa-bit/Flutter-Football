import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/auth_repository.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthState()) {

    on<IsUserAuthenticated>((event, emit) async {
      /*try {
        final team = await repository.getTeam(event.teamId);
        emit(state.copyWith(teamDetail: team, status: TeamStatus.success));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: TeamStatus.error,
        ));
      }*/
    });

    on<AuthenticateUser>((event, emit) async {
      /*try {
        final team = await repository.getTeam(event.teamId);
        emit(state.copyWith(teamDetail: team, status: TeamStatus.success));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: TeamStatus.error,
        ));
      }*/
    });

  }
}
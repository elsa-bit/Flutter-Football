import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/login_repository.dart';
import 'package:flutter_football/presentation/blocs/login/login_event.dart';
import 'package:flutter_football/presentation/blocs/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc({required this.repository}) : super(LoginState()) {

    on<LoginCoach>((event, emit) async {
      try {
        emit(state.copyWith(status: LoginStatus.loading));
        final user = await repository.loginCoach(event.email, event.password);
        print(user);
        emit(state.copyWith(token: "token", status: LoginStatus.success));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: LoginStatus.error,
        ));
      }
    });

    on<LoginMember>((event, emit) async {
      try {
        emit(state.copyWith(status: LoginStatus.loading));
        final user = await repository.loginMember(event.email, event.password);
        print(user);
        emit(state.copyWith(token: "token", status: LoginStatus.success));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: LoginStatus.error,
        ));
      }
    });

    on<LoginTest>((event, emit) async {
      try {
        emit(state.copyWith(status: LoginStatus.loading));
        final response = await repository.loginTest(event.email, event.password);
        emit(state.copyWith(token: response.session?.accessToken, status: LoginStatus.success));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: LoginStatus.error,
        ));
      }
    });

  }
}
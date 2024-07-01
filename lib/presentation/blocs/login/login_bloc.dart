import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/login_repository.dart';
import 'package:flutter_football/presentation/blocs/login/login_event.dart';
import 'package:flutter_football/presentation/blocs/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc({required this.repository}) : super(LoginState()) {

    on<Login>((event, emit) async {
      try {
        emit(state.copyWith(status: LoginStatus.loading));
        final response = await repository.login(event.email, event.password);
        emit(state.copyWith(authResponse: response, status: LoginStatus.success));
      } catch (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: LoginStatus.error,
        ));
      }
    });

  }
}
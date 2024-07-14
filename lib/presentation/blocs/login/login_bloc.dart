import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/domain/repositories/login_repository.dart';
import 'package:flutter_football/main.dart';
import 'package:flutter_football/presentation/blocs/login/login_event.dart';
import 'package:flutter_football/presentation/blocs/login/login_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc({required this.repository}) : super(LoginState()) {

    on<Login>((event, emit) async {
      try {
        emit(state.copyWith(status: LoginStatus.loading));
        final response = await repository.login(event.email, event.password);
        emit(state.copyWith(authResponse: response, status: LoginStatus.success));
      } on AuthException catch(error) {
        if (error.statusCode == "400" && event.password.length == 6) {
          try {
            // First sign in with Token
            final authResponse = await supabase.auth.verifyOTP(
              email: event.email,
              token: event.password,
              type: OtpType.signup,
            );
            print(authResponse);
            emit(state.copyWith(
              authResponse: authResponse,
              status: LoginStatus.signUpSuccess,
            ));
          } catch (authError) {
            print(authError);
            emit(state.copyWith(
              error: error,
              status: LoginStatus.error,
            ));
          }
        } else {
          print(error);
          emit(state.copyWith(
            error: error,
            status: LoginStatus.error,
          ));
        }

      } on Exception catch (error) {
        emit(state.copyWith(
          error: error,
          status: LoginStatus.error,
        ));
      }
    });

  }
}
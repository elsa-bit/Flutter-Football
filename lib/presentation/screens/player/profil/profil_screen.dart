import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_themes.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_state.dart';

class ProfilScreen extends StatelessWidget {
  static const String routeName = '/player/profil';

  const ProfilScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const ProfilScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Profil"),
          ),
          body: Column(
            children: [
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final authBloc = BlocProvider.of<AuthBloc>(context);
                    authBloc.add(Logout());
                  },
                  child: Text(
                    "Déconnexion",
                    style: AppTextStyle.subtitle1.copyWith(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
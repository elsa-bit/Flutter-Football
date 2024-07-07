import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/domain/models/user.dart';
import 'package:flutter_football/presentation/blocs/players/players_bloc.dart';
import 'package:flutter_football/presentation/blocs/players/players_event.dart';
import 'package:flutter_football/presentation/blocs/players/players_state.dart';
import 'package:flutter_football/presentation/screens/player/profil/contact_item.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlayersBloc>(context).add(GetCoachPlayer());
  }

  List<List<Coach>> _groupCoaches(List<Coach> coaches) {
    List<List<Coach>> groupedCoaches = [];
    for (int i = 0; i < coaches.length; i += 2) {
      groupedCoaches.add(
        coaches.sublist(i, i + 2 > coaches.length ? coaches.length : i + 2),
      );
    }
    return groupedCoaches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Administration",
                style: TextStyle(
                  color: currentAppColors.secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ContactItem(
                  firstname: 'Amaury',
                  lastname: 'Dubreuil',
                  email: '500217@lpiff.fr',
                ),
                ContactItem(
                  firstname: 'Anthony',
                  lastname: 'Allanche Ferreira',
                  email: 'a.allanche@gmail.com',
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(
                "Coachs",
                style: TextStyle(
                  color: currentAppColors.secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            BlocBuilder<PlayersBloc, PlayersState>(
              builder: (context, state) {
                switch (state.status) {
                  case PlayersStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case PlayersStatus.error:
                    return Center(
                      child: Text(
                        state.error,
                      ),
                    );
                  case PlayersStatus.success:
                    if (state.coachs!.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 46.0),
                        child: const Center(
                          child: Text(
                            "Pas de coach disponible",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      );
                    }
                    final groupedCoaches = _groupCoaches(state.coachs!);
                    return Expanded(
                      child: ListView.builder(
                        itemCount: groupedCoaches.length,
                        itemBuilder: (context, index) {
                          final group = groupedCoaches[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: group.map((coach) {
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 4.0,
                                  ),
                                  child: ContactItem(
                                    firstname: coach.firstName,
                                    lastname: coach.lastName,
                                    email: coach.email,
                                    urlAvatar: coach.avatar,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    );
                  default:
                    return Padding(
                      padding: const EdgeInsets.only(top: 46.0),
                      child: const Center(
                        child: Text(
                          "Pas de coach disponible",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

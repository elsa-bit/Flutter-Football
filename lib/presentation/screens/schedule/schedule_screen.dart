import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/data/data_sources/schedule_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/event.dart';
import 'package:flutter_football/domain/repositories/schedule_repository.dart';
import 'package:flutter_football/presentation/blocs/schedule/schedule_bloc.dart';
import 'package:flutter_football/presentation/blocs/schedule/schedule_event.dart';
import 'package:flutter_football/presentation/blocs/schedule/schedule_state.dart';
import 'package:flutter_football/presentation/screens/schedule/schedule_item.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  static const String routeName = '/';

  const ScheduleScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const ScheduleScreen(),
    );
  }

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  TextEditingController _placeController = TextEditingController();
  TextEditingController? _opponentController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;
  String? _selectedEventType;
  final List<Map<String, String>> _eventTypes = [
    {'id': 'match', 'name': 'Match'},
    {'id': 'training', 'name': 'Entrainement'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ScheduleRepository(
          scheduleDataSource: ScheduleDataSource(),
          preferencesDataSource: SharedPreferencesDataSource()),
      child: BlocProvider(
        create: (context) => ScheduleBloc(
          repository: RepositoryProvider.of<ScheduleRepository>(context),
        )..add(GetSchedules(idteams: "2,4")),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _displayAlertDialogToAddSchedule(context),
            child: Icon(Icons.add),
          ),
          body: BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, state) {
              switch (state.status) {
                case ScheduleStatus.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ScheduleStatus.error:
                  return Center(
                    child: Text(
                      state.error,
                    ),
                  );
                case ScheduleStatus.success:
                  if (state.matchs!.isEmpty &&
                      state.trainings!.isEmpty &&
                      state.meetings!.isEmpty) {
                    return Center(
                      child: Text("Calendrier vide !"),
                    );
                  }

                  events.clear();
                  for (var match in state.matchs!) {
                    DateTime eventDate = DateTime(
                        match.date.year, match.date.month, match.date.day);

                    events.update(
                      eventDate,
                      (existingEvents) => existingEvents
                        ..add(Event("Match", 'match', match.date,
                            match.nameTeam, null, null, match.opponentName)),
                      ifAbsent: () => [
                        Event("Match", 'match', match.date, match.nameTeam,
                            null, null, match.opponentName)
                      ],
                    );
                  }
                  for (var training in state.trainings!) {
                    DateTime eventDate = DateTime(training.date.year,
                        training.date.month, training.date.day);

                    events.update(
                      eventDate,
                      (existingEvents) => existingEvents
                        ..add(Event("Entrainement", 'training', training.date,
                            training.nameTeam, training.place, null, null)),
                      ifAbsent: () => [
                        Event("Entrainement", 'training', training.date,
                            training.nameTeam, training.place, null, null)
                      ],
                    );
                  }
                  for (var meeting in state.meetings!) {
                    DateTime eventDate = DateTime(meeting.date_debut.year,
                        meeting.date_debut.month, meeting.date_debut.day);

                    events.update(
                      eventDate,
                      (existingEvents) => existingEvents
                        ..add(Event("Réunion", 'meeting', meeting.date_debut,
                            null, null, meeting.name, null)),
                      ifAbsent: () => [
                        Event("Réunion", 'meeting', meeting.date_debut, null,
                            null, meeting.name, null)
                      ],
                    );
                  }
                  _selectedEvents.value = _getEventsForDay(_selectedDay!);

                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30.0),
                        child: TableCalendar(
                          locale: 'fr_FR',
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2100, 12, 31),
                          focusedDay: _focusedDay,
                          headerStyle: HeaderStyle(
                              formatButtonVisible: false, titleCentered: true),
                          calendarFormat: _calendarFormat,
                          calendarStyle: CalendarStyle(
                            defaultTextStyle: TextStyle(
                                color: currentAppColors.secondaryColor),
                            weekendTextStyle: TextStyle(
                                color: currentAppColors.secondaryColor),
                            selectedDecoration: BoxDecoration(
                              color: currentAppColors.secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color: AppColors.darkBlue,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            if (!isSameDay(_selectedDay, selectedDay)) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                                _selectedEvents.value =
                                    _getEventsForDay(selectedDay);
                              });
                            }
                          },
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                          eventLoader: (day) => _getEventsForDay(day),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Expanded(
                        child: ValueListenableBuilder<List<Event>>(
                          valueListenable: _selectedEvents,
                          builder: (context, value, _) {
                            return ListView.builder(
                                itemCount: value.length,
                                itemBuilder: (context, index) {
                                  debugPrint("VALUE : " + value.toString());
                                  return ScheduleItem(event: value[index]);
                                });
                          },
                        ),
                      ),
                    ],
                  );
                default:
                  return Center(
                    child: Text("Calendrier vide !"),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    DateTime specialDay = DateTime(day.year, day.month, day.day);
    return events[specialDay] ?? [];
  }

  void _showSnackBar(BuildContext context, String text, Color background) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: background,
      ),
    );
  }

  Future<void> _displayAlertDialogToAddSchedule(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: BlocProvider.of<ScheduleBloc>(context),
            child: BlocConsumer<ScheduleBloc, ScheduleState>(
              listener: (context, state) {
                if (state.status == ScheduleStatus.addSuccess) {
                  _showSnackBar(
                      context, 'Evenement ajouté', Colors.greenAccent);
                  _placeController.text = "";
                  _opponentController?.text = "";

                  setState(() {
                    _selectedEvents.value = _getEventsForDay(_selectedDay!);
                    debugPrint("SELECT DAY: " + _selectedDay.toString());
                    debugPrint(
                        "SELECT EVENTS: " + _selectedEvents.value.toString());
                  });

                  Navigator.pop(context);
                } else if (state.status == ScheduleStatus.error) {
                  _showSnackBar(context, state.error, Colors.orangeAccent);
                  _placeController.text = "";
                  _opponentController?.text = "";
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case ScheduleStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        title: const Text("Ajouter un évenement"),
                        content: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration:
                                    InputDecoration(labelText: "Lieu *"),
                                controller: _placeController,
                              ),
                              SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                    labelText: 'Type d\'événement'),
                                items: _eventTypes.map((type) {
                                  return DropdownMenuItem<String>(
                                    value: type['id'],
                                    child: Text(type['name']!),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedEventType = value;
                                  });
                                },
                                value: _selectedEventType,
                              ),
                              if (_selectedEventType == 'match') ...[
                                SizedBox(height: 16),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: "Nom de l'adversaire *",
                                  ),
                                  controller: _opponentController,
                                ),
                              ],
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () => _onAddSchedule(context),
                              child: Text("Enregistrer"))
                        ],
                      );
                    });
                }
              },
            ),
          );
        });
  }

  void _onAddSchedule(BuildContext context) async {
    var bloc = BlocProvider.of<ScheduleBloc>(context);

    if (_placeController.text != '') {
      if (_selectedEventType != null) {
        if (_selectedEventType == 'match') {
          if (_opponentController!.text != "") {
            final event = Event("Match", _selectedEventType!, _selectedDay!,
                null, _placeController.text, null, _opponentController?.text);
            bloc.add(AddSchedule(event: event, date: _selectedDay!));

            DateTime eventDate = DateTime(
                _selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
            events.update(
              eventDate,
              (existingEvents) => existingEvents..add(event),
              ifAbsent: () => [event],
            );
          } else {
            _showSnackBar(context, 'Veuillez saisir le nom de l\'adversaire.',
                Colors.orangeAccent);
          }
        } else {
          final event = Event("Entrainement", _selectedEventType!,
              _selectedDay!, null, _placeController.text, null, null);
          bloc.add(AddSchedule(event: event, date: _selectedDay!));

          DateTime eventDate = DateTime(
              _selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
          events.update(
            eventDate,
            (existingEvents) => existingEvents..add(event),
            ifAbsent: () => [event],
          );
        }
      } else {
        _showSnackBar(context, 'Veuillez sélectionner un type d\'événement.',
            Colors.orangeAccent);
      }
    } else {
      _showSnackBar(context, 'Veuillez remplir le lieu de l\'événement.',
          Colors.orangeAccent);
    }
  }
}

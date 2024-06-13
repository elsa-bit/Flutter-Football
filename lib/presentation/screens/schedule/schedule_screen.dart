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
  TextEditingController _eventController = TextEditingController();
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
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text("Ajouter un évenement"),
                      content: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(labelText: "Sujet *"),
                              controller: _eventController,
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
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              _onAddSchedule(context);
                              final event = Event(
                                  _eventController.text,
                                  _selectedEventType!,
                                  DateTime.now(),
                                  null,
                                  null,
                                  null,
                                  null);
                              setState(() {
                                events.update(
                                  _selectedDay!,
                                  (existingEvents) =>
                                      existingEvents..add(event),
                                  ifAbsent: () => [event],
                                );
                              });
                              Navigator.of(context).pop();
                              _selectedEvents.value =
                                  _getEventsForDay(_selectedDay!);
                            },
                            child: Text("Enregistrer"))
                      ],
                    );
                  });
            },
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

  void _onAddSchedule(BuildContext context) async {
    var bloc = BlocProvider.of<ScheduleBloc>(context);

    if (_eventController.text != '') {
      if (_selectedEventType != null) {
        final event = Event(_eventController.text, _selectedEventType!,
            DateTime.now(), null, null, null, null);
        bloc.add(AddSchedule(event: event, date: _selectedDay!));
        _eventController.text = "";
      } else {
        _showSnackBar(context, 'Veuillez sélectionner un type d\'événement.',
            Colors.orangeAccent);
      }
    } else {
      _showSnackBar(context, 'Veuillez remplir le nom d\'événement.',
          Colors.orangeAccent);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/domain/models/event.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_football/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_football/presentation/blocs/schedule/schedule_bloc.dart';
import 'package:flutter_football/presentation/blocs/schedule/schedule_event.dart';
import 'package:flutter_football/presentation/blocs/schedule/schedule_state.dart';
import 'package:flutter_football/presentation/screens/coach/schedule/schedule_item.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  static const String routeName = '/player/calendar';

  const CalendarScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const CalendarScreen(),
    );
  }

  @override
  State<CalendarScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  late ValueNotifier<List<Event>> _selectedEvents;
  SharedPreferencesDataSource sharedPreferencesDataSource =
      SharedPreferencesDataSource();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    BlocProvider.of<ScheduleBloc>(context).add(GetSchedulesPlayer());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                Event event = Event(
                    match.id.toString(),
                    "Match",
                    'match',
                    match.date,
                    match.nameTeam,
                    match.idTeam,
                    null,
                    null,
                    match.opponentName,
                    null);
                DateTime eventDate =
                    DateTime(match.date.year, match.date.month, match.date.day);

                events.update(
                  eventDate,
                  (existingEvents) => existingEvents..add(event),
                  ifAbsent: () => [event],
                );
              }
              for (var training in state.trainings!) {
                Event event = Event(
                    training.id.toString(),
                    "Entrainement",
                    'training',
                    training.date,
                    training.nameTeam,
                    training.idTeam,
                    training.place,
                    null,
                    null,
                    training.presence);
                DateTime eventDate = DateTime(
                    training.date.year, training.date.month, training.date.day);

                events.update(
                  eventDate,
                  (existingEvents) => existingEvents..add(event),
                  ifAbsent: () => [event],
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
                        defaultTextStyle:
                            TextStyle(color: currentAppColors.secondaryColor),
                        weekendTextStyle:
                            TextStyle(color: currentAppColors.secondaryColor),
                        selectedDecoration: BoxDecoration(
                          color: currentAppColors.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppColors.darkBlue,
                          shape: BoxShape.circle,
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
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    DateTime specialDay = DateTime(day.year, day.month, day.day);
    return events[specialDay] ?? [];
  }
}

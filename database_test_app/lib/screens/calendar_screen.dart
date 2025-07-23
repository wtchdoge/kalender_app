import 'package:database_test_app/main.dart' show routeObserver;
import 'package:database_test_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:database_test_app/widgets/day_details_row.dart';
import 'package:database_test_app/widgets/calendar_action_bar.dart';
import 'package:database_test_app/models/appointment_model.dart';
import 'package:database_test_app/services/availability_service.dart';
import 'package:database_test_app/services/appointment_service.dart';

enum SelectionMode { viewOnly, available, unavailable }


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with RouteAware {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<DateTime> _selectedDays = [];
  SelectionMode _selectionMode = SelectionMode.viewOnly;

  Map<DateTime, List<Appointment>> _termineByDate = {};
  List<Appointment> _selectedAppointments = [];
  Set<DateTime> _notAvailableDays = {};
  Map<DateTime, List<String>> _notAvailableByDate = {}; // date -> List<Mitarbeitername>

  void _resetSelectedDays() {
    setState(() {
      _selectedDays.clear();
      _selectedDay = null;
      _selectedAppointments = [];
    });
  }

  void _onStartSelection(SelectionMode mode) {
    setState(() {
      _selectionMode = mode;
      _selectedDays.clear();
      _selectedDay = null;
      _selectedAppointments = [];
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Wird aufgerufen, wenn man von einer anderen Route zurückkehrt
    _loadData();
    super.didPopNext();
  }

// WICHTIG: Füge in main.dart beim MaterialApp folgenden Eintrag hinzu:
// navigatorObservers: [routeObserver],
// und deklariere dort global:
// final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  Future<void> _loadData() async {
    final result = await AvailabilityService.loadAppointmentsAndAvailability();
    setState(() {
      _termineByDate = result.termineByDate;
      _selectedAppointments = _termineByDate[_selectedDay] ?? [];
      _notAvailableDays = result.notAvailableByDate.keys.toSet();
      _notAvailableByDate = result.notAvailableByDate;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalender')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) =>
                _selectionMode == SelectionMode.viewOnly
                    ? isSameDay(_selectedDay, day)
                    : _selectedDays.any((d) => isSameDay(d, day)),
            eventLoader: (day) => AppointmentService.getAppointmentsForDay(_termineByDate, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _focusedDay = focused;
                if (_selectionMode == SelectionMode.viewOnly) {
                  // Einzelwahl wie gewohnt
                  _selectedDay = selected;
                  _selectedDays = [selected];
                  _selectedAppointments = AppointmentService.getAppointmentsForDay(_termineByDate, selected);
                } else {
                  // Multi-Select-Logik
                  final dayKey = DateTime(selected.year, selected.month, selected.day);
                  if (_selectedDays.any((d) => isSameDay(d, dayKey))) {
                    _selectedDays.removeWhere((d) => isSameDay(d, dayKey));
                  } else {
                    _selectedDays.add(dayKey);
                  }
                  _selectedDay = _selectedDays.isNotEmpty ? _selectedDays.last : null;
                  _selectedAppointments = _selectedDay != null
                      ? AppointmentService.getAppointmentsForDay(_termineByDate, _selectedDay!)
                      : [];
                }
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final dayKey = DateTime(date.year, date.month, date.day);
                final isNotAvailable = _notAvailableDays.contains(dayKey);
                List<Widget> markers = [];
                if (events.isNotEmpty) {
                  markers.add(Positioned(
                    bottom: 1,
                    child: Icon(Icons.event_note, color: AppColors.secondary, size: 16),
                  ));
                }
                if (isNotAvailable) {
                  markers.add(Positioned(
                    top: 1,
                    right: 1,
                    child: Icon(Icons.block, color: AppColors.accent, size: 16),
                  ));
                }
                if (markers.isNotEmpty) {
                  return Stack(children: markers);
                }
                return const SizedBox();
              },
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.primary, // Hauptfarbe für heute
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.accent, // Akzentfarbe für ausgewählt
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: AppColors.secondary, // Sekundärfarbe für Marker
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Builder(
              builder: (context) {
                final dayKey = _selectedDay != null
                    ? DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)
                    : null;
                final notAvailableList = dayKey != null ? _notAvailableByDate[dayKey] : null;
                return DayDetailsRow(
                  appointments: _selectedAppointments,
                  notAvailableList: notAvailableList,
                  dayKey: dayKey,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CalendarActionBar(
        selectedDays: _selectedDays,
        selectionMode: _selectionMode,
        onReload: _loadData,
        onResetSelection: _resetSelectedDays,
        onStartSelection: _onStartSelection,
      ),
    );
  }
}
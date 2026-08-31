import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ZimPlantingCalendar extends StatefulWidget {
  const ZimPlantingCalendar({super.key});
  @override
  State<ZimPlantingCalendar> createState() => _ZimPlantingCalendarState();
}

class _ZimPlantingCalendarState extends State<ZimPlantingCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Key crops for Zimbabwe
  final Map<String, List<int>> plantingMonths = {
    'Maize': [10, 11, 12], // Oct - Dec
    'Soybeans': [11, 12],
    'Tobacco': [9, 10], // Sep - Oct seedbeds
    'Groundnuts': [11, 12],
    'Sorghum': [11, 12, 1],
    'Tomatoes': [8, 9, 1, 2], // Year round with irrigation
    'Cabbage': [3, 4, 8, 9],
    'Onion': [2, 3, 8, 9],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🇿🇼 Zimbabwe Planting Calendar')),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2024),
            lastDay: DateTime(2026),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) {
                final cropsToPlant = _getCropsForMonth(day.month);
                return cropsToPlant.isNotEmpty 
                  ? Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle),
                      child: Center(child: Text('${day.day}')))
                  : null;
              }
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: plantingMonths.entries.map((e) => 
                ListTile(
                  title: Text(e.key),
                  subtitle: Text('Plant in: ${_months(e.value)}'),
                  trailing: const Icon(Icons.agriculture)
                )
              ).toList(),
            ),
          )
        ],
      ),
    );
  }

  List<String> _getCropsForMonth(int month) {
    return plantingMonths.entries
        .where((e) => e.value.contains(month))
        .map((e) => e.key)
        .toList();
  }

  String _months(List<int> months) {
    const names = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months.map((m) => names[m-1]).join(', ');
  }
}

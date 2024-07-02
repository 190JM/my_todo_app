import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/utils/data_utils.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/todo_item.dart';

class TodoCalendar extends StatefulWidget {
  final Function(PageController) onCalendarCreated;
  final Function(DateTime) onPageChange;
  final Function(DateTime, List<TodoItem>) onSelectedDate;
  final List<TodoItem> todoItmes;
  final DateTime focusMonth;

  const TodoCalendar({
    super.key,
    required this.focusMonth,
    required this.onCalendarCreated,
    required this.onPageChange,
    required this.onSelectedDate,
    required this.todoItmes,
  });

  @override
  State<TodoCalendar> createState() => _TodoCalendarState();
}

class _TodoCalendarState extends State<TodoCalendar> {
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  List<TodoItem> todoItems = [];

  @override
  void initState() {
    super.initState();
    setTodoItems();
  }

  void setTodoItems() {
    todoItems = widget.todoItmes;
    _focusedDay = widget.focusMonth;
    update();
  }

  void update() => setState(() {});

  @override
  void didUpdateWidget(TodoCalendar oldWidget) {
    if (todoItems != widget.todoItmes) {
      setTodoItems();
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _dowHeaderStyle({required String date, required Color color}) {
    return Center(
      child: SizedBox(
        height: 30,
        child: Text(
          date,
          style: GoogleFonts.notoSans(color: color, fontSize: 13),
        ),
      ),
    );
  }

  Widget _dayStyle({
    required DateTime date,
    Color? color,
    bool isToday = false,
    bool isSelected = false,
    bool isComplete = false,
  }) {
    var backgroundColor = Colors.white;
    if (isToday) backgroundColor = const Color(0xffbebfc7);
    // if (isSelected) backgroundColor = const Color(0xff4a69ea);
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: Text(
              '${date.day}',
              style: GoogleFonts.notoSans(
                  color: isToday ? Colors.white : color, fontSize: 16),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Builder(builder: (context) {
                var items = TodoDataUtils.findTodoListByDateTime(todoItems, date);
                return items.isNotEmpty
                    ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isComplete ? const Color(0xff57A8ED) : Colors.pinkAccent,
                    ),
                    width: 5,
                    height: 5)
                    : Container();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customDayBuilder({
    required DateTime date,
    bool isSelected = false,
    bool isComplete = false,
    bool isToday = false,
  }) {
    var items = TodoDataUtils.findTodoListByDateTime(todoItems, date);
    var itemCount = items.length;
    var completeItems = TodoDataUtils.findCompleteListByDateTime(todoItems, date);
    var completeItemCount=completeItems.length;
    var todoItemCount=itemCount-completeItemCount;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 큰 원
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isToday ? Colors.greenAccent : const Color(0xffB1D9F6),
            ),
          ),
          // 작은 원
          if (completeItemCount > 0)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration:  const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff57A8ED),
                ),
                child: Center(
                  child: Text(
                    '$completeItemCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
          if (todoItemCount > 0)
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration:  const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pinkAccent,
                ),
                child: Center(
                  child: Text(
                    '$todoItemCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
          // 중앙의 숫자
          Text(
            '${date.day}',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      headerVisible: false,
      locale: 'ko_KR',
      firstDay: DateTime(DateTime.now().year, 1, 1),
      lastDay: DateTime(DateTime.now().year + 2, 1, 1),
      focusedDay: _focusedDay ?? DateTime.now(),
      calendarFormat: CalendarFormat.month,
      calendarStyle: const CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Color(0xffB1D9F6),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16
        ),
        todayDecoration: BoxDecoration(
          color: Color(0xFF4DA9FF),
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
          });
          widget.onSelectedDate(selectedDay,
              TodoDataUtils.findTodoListByDateTime(todoItems, selectedDay));
        }
      },
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, date) {
          // 월~토
          return _dowHeaderStyle(
            date: TodoDataUtils.convertWeekdayToStringValue(date.weekday),
            color: TodoDataUtils.dayToColor(date),
          );
        },
        selectedBuilder: (context, date, _) => _customDayBuilder(
          date: date,
          isSelected: true,
          isComplete: TodoDataUtils.isComplete(todoItems, date),
        ),
        todayBuilder: (context, date, _) => _customDayBuilder(
          date: date,
          isToday: true,
          isComplete: TodoDataUtils.isComplete(todoItems, date),
        ),
        defaultBuilder: (context, date, _) => _dayStyle(
          date: date,
          color: TodoDataUtils.dayToColor(date),
          isToday: isSameDay(date, DateTime.now()),
          isSelected: isSameDay(_selectedDay, date),
          isComplete: TodoDataUtils.isComplete(todoItems, date),
        ),
        outsideBuilder: (context, date, _) => _dayStyle(
          date: date,
          color: TodoDataUtils.dayToColor(date, opacity: 0.3),
          isComplete: TodoDataUtils.isComplete(todoItems, date),
        ),
      ),
      onCalendarCreated: widget.onCalendarCreated,
      onFormatChanged: (format) {},
      onPageChanged: widget.onPageChange,
    );
  }
}
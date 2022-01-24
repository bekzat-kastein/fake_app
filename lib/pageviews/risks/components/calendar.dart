import 'package:flutter/material.dart';
import 'package:hse/core/companents/widgets/no_data.dart';
import 'package:hse/core/service/local/calendar/calendar_widgets.dart';
import 'package:hse/core/utils/UI_Helpers.dart';
import 'package:hse/core/utils/globals.dart';
import 'package:hse/pageviews/risks/widgets/risks_item.dart';
import 'package:hse/viewmodels/bpm_models/risks_model.dart';
import 'package:hse/viewmodels/user_info.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';
import 'package:hse/generated/l10n.dart';

class RisksManagementCalendar extends StatefulWidget {
  final RisksModel model;
  const RisksManagementCalendar(this.model);

  @override
  _RisksManagementCalendarState createState() => _RisksManagementCalendarState();
}

class _RisksManagementCalendarState extends State<RisksManagementCalendar> {
  final CalendarController _calendarController = CalendarController();
  List eventList;
  RisksModel riskModel;
  DateTime today;

  @override
  void initState() {
    riskModel = widget.model;
    today = DateTime.now();
    eventList = getEventsByDay(today, riskModel.risksEvents);
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserInfoModel>(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TableCalendar(
        locale: userModel.localeCode,
        events: riskModel.risksEvents,
        initialSelectedDay: today,
        initialCalendarFormat: CalendarFormat.month,
        calendarController: _calendarController,
        rowHeight: 55,
        availableGestures: AvailableGestures.horizontalSwipe,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(
            weekdayStyle:
            generalFontStyle.copyWith(fontWeight: FontWeight.w600),
            weekendStyle: generalFontStyle.copyWith(
                fontWeight: FontWeight.w600, color: appOrangeColor),
            selectedColor: Colors.blue[400],
            todayColor: Colors.blue[200],
            markersColor: Colors.blue[700],
            outsideDaysVisible: true,
            canEventMarkersOverflow: true
        ),
        onDaySelected: (date, events, holidays) {
          setState(() {
            eventList = events;
          });
        },
        daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: generalFontStyle.copyWith(color: Colors.white),
            weekendStyle: generalFontStyle.copyWith(color: Colors.white)),
        headerStyle: HeaderStyle(
            leftChevronIcon: Icon(Icons.chevron_left, color: appGreyColor),
            leftChevronPadding: EdgeInsets.only(left: 50),
            rightChevronIcon: Icon(Icons.chevron_right, color: appGreyColor),
            rightChevronPadding: EdgeInsets.only(right: 50),
            titleTextStyle: generalFontStyle.copyWith(
                color: appOrangeColor,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            centerHeaderTitle: true,
            formatButtonVisible: false),
        builders: CalendarBuilders(
          todayDayBuilder: (context, date, _) {
            return Container(
              decoration: BoxDecoration(
                color: appGreyColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: appGreyColor.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              margin: const EdgeInsets.all(6.0),
              width: 125,
              height: 150,
              child: Center(
                  child: Text(
                    '${date.day}\n' + DateFormat('EEE').format(date),
                    textAlign: TextAlign.center,
                    style: generalFontStyle.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.white),
                  )),
            );
          },
          selectedDayBuilder: (context, date, _) {
            return Container(
              decoration: BoxDecoration(
                color: appBlueColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: appBlueColor.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              margin: const EdgeInsets.all(6.0),
              width: 125,
              height: 150,
              child: Center(
                  child: Text(
                    '${date.day}\n' + DateFormat('EEE').format(date),
                    textAlign: TextAlign.center,
                    style: generalFontStyle.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  )),
            );
          },
          markersBuilder: (context, date, events, holidays) {
            final children = <Widget>[];
            if (events.isNotEmpty) {
              children.add(
                Positioned(
                  bottom: 0,
                  right: 2,
                  child: buildEventsMarkerNum(events),
                ),
              );
            }
            return children;
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          S.current.listAssessment,
          style: generalFontStyle.copyWith(fontSize: 16),
        ),
      ),
      Expanded(
          child: SingleChildScrollView(
            child: eventList.isNotEmpty
                ? Column(
              children: eventList
                  .map((e) => InkWell(
                child: RisksItem(e),
                onTap: () async {
                  await riskModel
                      .openEntity(e)
                      .then((_) => setState(() {
                    print('back2');
                  }));
                },
              ))
                  .toList(),
            )
                : Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 48,
                ),
                child: NoDataWidget(),
              ),
            ),
          ))
    ]);
  }
}
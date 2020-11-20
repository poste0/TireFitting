import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tire_fitting/Request.dart';

import 'RequestDataSource.dart';

class RequestCalendarAdd extends StatefulWidget {
  DateTime time;

  List<Request> dataSource;

  RequestCalendarAdd([this.time, this.dataSource]);

  @override
  _RequestCalendarAddState createState() => _RequestCalendarAddState(time, dataSource);
}

class _RequestCalendarAddState extends State<RequestCalendarAdd> {
  DateTime time;

  List<Request> requests;

  _RequestCalendarAddState([this.time, this.requests]);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCalendar(
        view: CalendarView.day,
        initialDisplayDate: time,
        dataSource: RequestDataSource(requests),
      ),
    );
  }
}

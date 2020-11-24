import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tire_fitting/RequestRepository.dart';
import 'package:tire_fitting/RequestType.dart';
import 'package:tire_fitting/ServicePoint.dart';
import 'package:tire_fitting/TireDismount.dart';

import 'Request.dart';
import 'RequestDataSource.dart';

class RequestCalendar extends StatefulWidget {
  ServicePoint servicePoint;

  RequestCalendar({Key key, ServicePoint servicePoint}) : super(key: key) {
    this.servicePoint = servicePoint;
  }

  @override
  _RequestCalendarState createState() => _RequestCalendarState(servicePoint);
}

class _RequestCalendarState extends State<RequestCalendar> {
  ServicePoint servicePoint;

  _RequestCalendarState([this.servicePoint]);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SfCalendar(
      view: CalendarView.month,
      dataSource: RequestDataSource(_getRequests()),
      monthViewSettings: MonthViewSettings(showAgenda: true),
    ));
  }

  List<Request> _getRequests() {
    List<Request> requests = RequestRepository().getRequests(servicePoint);

    return requests;
  }
}

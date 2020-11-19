import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tire_fitting/RequestType.dart';
import 'package:tire_fitting/ServicePoint.dart';
import 'package:tire_fitting/TireDismount.dart';

import 'Request.dart';

class RequestCalendar extends StatefulWidget {
  ServicePoint servicePoint;

  RequestCalendar({Key key, ServicePoint servicePoint}) : super(key: key){
    this.servicePoint = servicePoint;
  }

  @override
  _RequestCalendarState createState() => _RequestCalendarState();
}

class _RequestCalendarState extends State<RequestCalendar> {
  List<Request> requests;

  @override
  Widget build(BuildContext context) {
    return Container(
          child: SfCalendar(
          view: CalendarView.month,
          dataSource: RequestDataSource(_getRequests()),
          monthViewSettings: MonthViewSettings(showAgenda: true),
        )
    );
  }

  List<Request> _getRequests(){
    print("get");
    requests = <Request>[];
    requests.add(Request(
      TireDismount(),
      14,
      DateTime.now()
    ));

    return requests;
  }
}

class RequestDataSource extends CalendarDataSource{
  RequestDataSource(List<Request> requests){
    print("source");
    appointments = requests;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].time;
  }

  @override
  String getSubject(int index) {
    return appointments[index].time.toString() + " name";
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].time.add(Duration(seconds: appointments[index].requestType.getDuration(appointments[index].wheelRadius).round()));
  }
}

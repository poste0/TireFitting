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
    return FutureBuilder(
      future: RequestRepository().getAll(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          List<Request> requests = snapshot.data as List<Request>;
          requests.forEach((element) {print(element.servicePoint.id);});
          requests = requests.where((element) => element.servicePoint == servicePoint).toList();
          return Container(
              child: SfCalendar(
                view: CalendarView.month,
                dataSource: RequestDataSource(requests),
                monthViewSettings: MonthViewSettings(showAgenda: true),
              ));
        }
        else{
          return CircularProgressIndicator();
        }
      }
    );
  }
}

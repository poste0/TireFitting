import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tire_fitting/data/RequestDataSource.dart';
import 'package:tire_fitting/data/RequestRepository.dart';
import 'package:tire_fitting/entity/Request.dart';
import 'package:tire_fitting/entity/ServicePoint.dart';
import 'file:///C:/TireFitting/tire_fitting/lib/main.dart';

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
    return Scaffold(
      appBar: getAppBar('calendar', context),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(flex: 10, child: Text(FlutterI18n.translate(context, 'calendar_for_service') + " " + servicePoint.address, style: getMainStyle(context))),
            Expanded(
              flex: 90,
              child: FutureBuilder(
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
                          initialSelectedDate: DateTime.now(),
                        ));
                  }
                  else{
                    return CircularProgressIndicator();
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

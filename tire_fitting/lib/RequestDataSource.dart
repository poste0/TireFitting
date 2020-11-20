import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'Request.dart';

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
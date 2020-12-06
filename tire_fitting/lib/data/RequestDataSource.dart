import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../entity/Request.dart';

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
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return dateFormat.format(appointments[index].time);
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].time.add(Duration(seconds: appointments[index].requestType.getDuration(appointments[index].wheelRadius).round()));
  }
}
import 'package:flutter/cupertino.dart';

class RequestCalendarAdd extends StatefulWidget {
  DateTime time;

  RequestCalendarAdd([this.time]);

  @override
  _RequestCalendarAddState createState() => _RequestCalendarAddState(time);
}

class _RequestCalendarAddState extends State<RequestCalendarAdd> {
  DateTime time;

  _RequestCalendarAddState([this.time]);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

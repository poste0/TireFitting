import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tire_fitting/RequestRepository.dart';
import 'package:tire_fitting/RequestType.dart';
import 'package:tire_fitting/ServicePointRepository.dart';
import 'package:tire_fitting/TireDismount.dart';

import 'Request.dart';
import 'ServicePoint.dart';

class RequestCreate extends StatefulWidget {
  @override
  _RequestCreateState createState() => _RequestCreateState();
}

class _RequestCreateState extends State<RequestCreate> {
  ServicePointRepository servicePointRepository = ServicePointRepository();
  RequestRepository requestRepository = RequestRepository();
  List<ServicePoint> servicePoints;
  ServicePoint currentServicePoint;
  RequestType currentRequestType;

  _RequestCreateState() {
    servicePoints = servicePointRepository.getAll();
    currentServicePoint = servicePoints.length > 0 ? servicePoints[0] : null;
  }

  List<RequestType> requestTypes = [TireDismount()];
  TextEditingController wheelRadiusController = TextEditingController();
  DateTime time;
  TimeOfDay timeOfDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        DropdownButton<ServicePoint>(
          value: currentServicePoint,
          items: servicePoints
              .map((e) => DropdownMenuItem<ServicePoint>(
                    child: Text(e.address.name),
                    value: e,
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              currentServicePoint = value;
            });
          },
        ),
        DropdownButton(
          value: currentRequestType,
            items: requestTypes
                .map((e) => DropdownMenuItem(child: Text(e.name), value: e))
                .toList(),
            onChanged: (value) {
              setState(() {
                currentRequestType = value;
              });
            }),
        FlatButton(
            onPressed: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 30)),
                ).then((value){
                  setState(() {
                    time = value;
                  });
            }),
            child: Text(time.toString())),
        FlatButton(
            onPressed: () => {
                  showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(hour: 0, minute: 0))
                      .then((value){
                        setState(() {
                          timeOfDay = value;
                        });
                  })
                },
            child: Text(timeOfDay.toString())),
        TextFormField(
          decoration: InputDecoration(
            labelText: "Wheel Radius",
          ),
          validator: (value) {
            return int.parse(value) < 13 || int.parse(value) > 18
                ? "Wheel Radius 13-18"
                : null;
          },
          keyboardType: TextInputType.number,
          controller: wheelRadiusController,
        ),
        FlatButton(
            onPressed: () => {
                  if (requestRepository.addRequest(Request(
                      currentRequestType,
                      int.parse(wheelRadiusController.value.text),
                      DateTime(time.year, time.month, time.day, timeOfDay.hour,
                          timeOfDay.minute),
                      currentServicePoint)))
                    {
                      showAboutDialog(context: context)
                    }
                  else{
                    print(1)
                  }
                },
            child: Text("Ok"))
      ],
    )));
  }
}

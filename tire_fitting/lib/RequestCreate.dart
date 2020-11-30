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
  Future<List<ServicePoint>> servicePoints;
  ServicePoint currentServicePoint;
  RequestType currentRequestType;

  _RequestCreateState() {
    servicePoints = servicePointRepository.getAll();
    //currentServicePoint = servicePoints.length > 0 ? servicePoints[0] : null;
  }

  List<RequestType> requestTypes = [TireDismount()];
  TextEditingController wheelRadiusController = TextEditingController();
  DateTime time;
  TimeOfDay timeOfDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Service point",
                  style: Theme.of(context).textTheme.headline1),
              FutureBuilder(
                future: servicePoints,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ServicePoint> servicePoints =
                        snapshot.data as List<ServicePoint>;
                    return DropdownButton<ServicePoint>(
                      value: currentServicePoint,
                      items: servicePoints
                          .map((e) => DropdownMenuItem<ServicePoint>(
                                child: Text(e.id),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          currentServicePoint = value;
                        });
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Request type",
                  style: Theme.of(context).textTheme.headline1),
              DropdownButton(
                  value: currentRequestType,
                  items: requestTypes
                      .map((e) =>
                          DropdownMenuItem(child: Text(e.name), value: e))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      currentRequestType = value;
                    });
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Date", style: Theme.of(context).textTheme.headline1),
              FlatButton(
                  onPressed: () => showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                      ).then((value) {
                        setState(() {
                          time = value;
                        });
                      }),
                  child: Text(time == null ? "Choose date" : time.toString())),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Time", style: Theme.of(context).textTheme.headline1),
              FlatButton(
                  onPressed: () => {
                        showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(hour: 0, minute: 0))
                            .then((value) {
                          setState(() {
                            timeOfDay = value;
                          });
                        })
                      },
                  child: Text(timeOfDay == null
                      ? "Choose time"
                      : timeOfDay.toString())),
            ],
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: "Wheel Radius",
                labelStyle: Theme.of(context).textTheme.headline1),
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
                    requestRepository
                        .addRequest(Request(
                            requestType: currentRequestType,
                            wheelRadius:
                                int.parse(wheelRadiusController.value.text),
                            time: DateTime(time.year, time.month, time.day,
                                timeOfDay.hour, timeOfDay.minute),
                            servicePoint: currentServicePoint))
                        .then((value) {
                      if (value) {
                        Navigator.pop(context);
                      }
                    })
                  },
              child: Text("Ok"))
        ],
      )),
    ));
  }
}

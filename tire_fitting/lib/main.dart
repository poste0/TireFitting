import 'package:flutter/material.dart';
import 'package:tire_fitting/RequestCalendar.dart';
import 'package:tire_fitting/RequestCreate.dart';
import 'package:tire_fitting/ServicePoint.dart';
import 'package:tire_fitting/ServicePointRepository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
              headline1: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
              headline2: TextStyle(
                  fontFamily: "Poppins", fontSize: 14, color: Colors.grey))),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ServicePointRepository servicePointRepository = ServicePointRepository();

  var key = GlobalKey<FormState>();
  var keys = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return _servicePointCard(
                        servicePointRepository.get(index), this);
                  },
                  itemCount: servicePointRepository.getSize(),
                ),
              ),
              Row(
                children: [
                  FlatButton(
                      onPressed: () => {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return _getCreateServiceDialog();
                                }).then((value) => {
                                  setState(() {
                                    String name = value[0] +
                                        ", " +
                                        value[1] +
                                        ", " +
                                        value[2];
                                    ServicePointRepository().addServicePoint(
                                        ServicePoint(
                                            name, int.parse(value[3])));
                                  })
                                })
                          },
                      child: Text("Create a service")),
                  FlatButton(
                      child: Text("Create a request"),
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RequestCreate()))
                          })
                ],
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  TextFormField _getAddressPartTextFormField(
      String part, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: part, labelStyle: Theme.of(context).textTheme.headline1),
      validator: (value) {
        return value.isEmpty ? part : null;
      },
    );
  }

  Widget _servicePointCard(ServicePoint servicePoint, State state) {
    return GestureDetector(
      onDoubleTap: () => {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(
                    "Service point " + servicePoint.address.toString(),
                    style: Theme.of(context).textTheme.headline1),
                actions: [
                  FlatButton(
                      onPressed: () {
                        servicePointRepository.removeServicePoint(servicePoint);
                        Navigator.pop(context);
                      },
                      child: Text("Delete",
                          style: Theme.of(context).textTheme.headline1)),
                  FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RequestCalendar(
                                      servicePoint: servicePoint,
                                    )));
                      },
                      child: Text("Calendar",
                          style: Theme.of(context).textTheme.headline1))
                ],
              );
            }).then((value) {
          state.setState(() {});
        })
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: [
                  Align(
                    child: Text("Address:" + servicePoint.address,
                        style: Theme.of(context).textTheme.headline1),
                    alignment: Alignment.centerLeft,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Count of stuff: " +
                            servicePoint.countOfStuff.toString(),
                        style: Theme.of(context).textTheme.headline1),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                FlatButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RequestCalendar(
                                servicePoint: servicePoint,
                              )));
                    },
                    child: Icon(Icons.calendar_today, color: Colors.blueGrey)
                ),
                FlatButton(
                  child: Icon(Icons.delete, color: Colors.blueGrey),
                  onPressed: (){
                    servicePointRepository.removeServicePoint(servicePoint);
                    setState(() {

                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Iterable<List<T>> zip<T>(Iterable<Iterable<T>> iterables) sync* {
    if (iterables.isEmpty) return;
    final iterators = iterables.map((e) => e.iterator).toList(growable: false);
    while (iterators.every((e) => e.moveNext())) {
      yield iterators.map((e) => e.current).toList(growable: false);
    }
  }

  AlertDialog _getCreateServiceDialog() {
    List<TextEditingController> controllers = [];
    final fieldCount = 4;
    for (var i = 0; i < fieldCount; i++) {
      controllers.add(TextEditingController());
    }

    return AlertDialog(
      title: Text("Create a service point",
          style: Theme.of(context).textTheme.headline1),
      content: Form(
        key: key,
        child: Column(
          children: [
            _getAddressPartTextFormField('City', controllers[0]),
            _getAddressPartTextFormField('Street', controllers[1]),
            _getAddressPartTextFormField('Building', controllers[2]),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Count',
                  labelStyle: Theme.of(context).textTheme.headline1),
              controller: controllers[3],
              keyboardType: TextInputType.number,
              validator: (value) {
                return value.isEmpty ? "Enter count" : null;
              },
            )
          ],
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () {
              List<String> texts = controllers.map((e) => e.text).toList();
              if (key.currentState.validate()) {
                Navigator.pop(context, texts);
              }
            },
            child: Text("Ok", style: Theme.of(context).textTheme.headline1)),
      ],
    );
  }

  AlertDialog _getCreateRequestDialog() {
    List<ServicePoint> servicePoints = servicePointRepository.getAll();
    ServicePoint currentServicePoint =
        servicePoints.length > 0 ? servicePoints[0] : null;
    int c = 0;
    print(servicePoints.length.toString() + "s");

    return AlertDialog(
      title: Text("Create a request"),
      key: keys,
      content: Column(
        children: [
          DropdownButton<int>(
            value: 1,
            items: servicePoints
                .map((e) => DropdownMenuItem<int>(
                      child: Text(e.countOfStuff.toString()),
                      value: e.countOfStuff,
                    ))
                .toList(),
            onChanged: (value) {
              if (keys.currentState.validate()) {
                setState(() {
                  c = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

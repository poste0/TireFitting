import 'package:flutter/material.dart';
import 'package:tire_fitting/Address.dart';
import 'package:tire_fitting/ServicePoint.dart';

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
  List<ServicePoint> servicePoints = [];

  var key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController cityController = TextEditingController();
    TextEditingController countOfStuffController = TextEditingController();
    TextEditingController streetController = TextEditingController();
    TextEditingController buildingController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return _servicePointCard(servicePoints[index], this);
                  },
                  itemCount: servicePoints.length,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return _getCreateServiceDialog();
              }).then((value) => {
                setState(() {
                  String name = value[0] + ", " + value[1] + ", " + value[2];
                  servicePoints.add(
                      ServicePoint(Address(name, 0, 0), int.parse(value[3])));
                })
              })
        },
        tooltip: 'Create a service',
        child: Icon(Icons.add),
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
                        servicePoints.remove(servicePoint);
                        Navigator.pop(context);
                      },
                      child: Text("Delete",
                          style: Theme.of(context).textTheme.headline1)),
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
            Column(
              children: [
                Text("Address", style: Theme.of(context).textTheme.headline1),
                Text(servicePoint.address.name,
                    style: Theme.of(context).textTheme.headline1)
              ],
            ),
            Column(
              children: [
                Text("Count of stuff",
                    style: Theme.of(context).textTheme.headline1),
                Text(servicePoint.countOfStuff.toString(),
                    style: Theme.of(context).textTheme.headline1)
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
    for(var i = 0; i < fieldCount; i++){
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
            _getAddressPartTextFormField(
                'Street', controllers[1]),
            _getAddressPartTextFormField(
                'Building', controllers[2]),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Count',
                  labelStyle:
                  Theme.of(context).textTheme.headline1),
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
            child: Text("Ok",
                style: Theme.of(context).textTheme.headline1)),
      ],
    );
  }
}

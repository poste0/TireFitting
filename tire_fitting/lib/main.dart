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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<ServicePoint> servicePoints = [];

  var key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    TextEditingController cityController = TextEditingController();
    TextEditingController countOfStuffController = TextEditingController();
    TextEditingController streetController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return servicePointCard(servicePoints[index]);
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
                return AlertDialog(
                  title: Text("Create a service point"),
                  content: Form(
                    key: key,
                    child: Column(
                      children: [
                        _getAddressPartTextFormField('City', cityController),
                        _getAddressPartTextFormField(
                            'Street', streetController),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Count'),
                          controller: countOfStuffController,
                          keyboardType: TextInputType.number,
                        )
                      ],
                    ),
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          if (key.currentState.validate()) {
                            Navigator.pop(context, [
                              cityController.text,
                              streetController.text,
                              countOfStuffController.text
                            ]);
                          }
                        },
                        child: Text("Ok")),
                  ],
                );
              }).then((value) => {
                setState(() {
                  String name = value[0] + " " + value[1];
                  servicePoints.add(
                      ServicePoint(Address(name, 0, 0), int.parse(value[2])));
                })
              })
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  TextFormField _getAddressPartTextFormField(
      String part, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: part),
      validator: (value) {
        return value.isEmpty ? part : null;
      },
    );
  }

  Widget servicePointCard(ServicePoint servicePoint) {
    return GestureDetector(
      onDoubleTap: () => {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog();
        }),
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [Text("Address"), Text(servicePoint.address.name)],
            ),
            Column(
              children: [
                Text("Count of stuff"),
                Text(servicePoint.countOfStuff.toString())
              ],
            )
          ],
        ),
      ),
    );
  }
}

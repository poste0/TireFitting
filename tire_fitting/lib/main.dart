import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tire_fitting/data/Repository.dart';
import 'package:tire_fitting/data/ServicePointRepository.dart';
import 'package:tire_fitting/entity/ServicePoint.dart';
import 'package:tire_fitting/ui/RequestCalendar.dart';
import 'package:tire_fitting/ui/RequestCreate.dart';
import 'package:tire_fitting/ui/ServicePointCreate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale locale = Locale('ru', 'RU');

  changeLanguage(Locale locale){
    setState(() {
      this.locale = locale;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        FlutterI18nDelegate(
            useCountryCode: true,
            path: "assets/flutter_i18n",
            forcedLocale: locale
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ru', 'RU')
      ],
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
      home: MyHomePage(changeLanguage: changeLanguage, currentLocale: locale,),
      locale: locale
    );
  }
}


class MyApps extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Locale locale = Locale('ru', 'RU');
    return MaterialApp(
      localizationsDelegates: [
        FlutterI18nDelegate(
          useCountryCode: true,
          path: "assets/flutter_i18n",
          forcedLocale: locale
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ru', 'RU')
      ],
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.changeLanguage, this.currentLocale}) : super(key: key);

  Function(Locale locale) changeLanguage;

  Locale currentLocale;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ServicePointRepository servicePointRepository = ServicePointRepository();

  var key = GlobalKey<FormState>();
  var keys = GlobalKey<FormState>();

  List<ServicePoint> servicePointList = [];

  _MyHomePageState();

  @override
  Widget build(BuildContext context) {
    Future<List<ServicePoint>> servicePoints = servicePointRepository.getAll();
    return Scaffold(
      appBar: getAppBar('service_points', context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(FlutterI18n.translate(context, 'language')),
                  ),
                  Expanded(
                      child:  DropdownButton(items: [
                        DropdownMenuItem(child: Text('English'), value: Locale('en', 'US'),),
                        DropdownMenuItem(child: Text('Русский'), value: Locale('ru', 'RU'),)
                      ], onChanged: (value){
                        widget.changeLanguage(value);
                      },
                        value: widget.currentLocale,
                      )
                  )
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: servicePoints,
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      return Text('Wrong' + snapshot.error.toString());
                    }
                    else if (snapshot.hasData) {
                      servicePointList = snapshot.data;
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return _servicePointCard(snapshot.data[index], this);
                        },
                        itemCount: snapshot.data.length,
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Card(
                      child: FlatButton(
                          /*onPressed: () => {
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
                                        ServicePointRepository().add(
                                            ServicePoint(
                                                address: name,
                                                countOfStuff: int.parse(value[3])));
                                      })
                                    })
                              },

                           */
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ServicePointCreate()))
                                .then((value) => setState(() {}));
                          },
                          child: Text(FlutterI18n.translate(context, "create_service"),
                              style: getMainStyle(context))),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Builder(
                        builder: (context) => FlatButton(
                            child: Text(
                              FlutterI18n.translate(context, "create_request"),
                              style: getMainStyle(context),
                            ),
                            onPressed: (){
                              if(servicePointList.isNotEmpty){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RequestCreate()));
                              }
                              else{
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(FlutterI18n.translate(context, "there_is_no_service_points")),
                                    action: SnackBarAction(
                                      label: 'Ok',
                                      onPressed: (){

                                      },
                                    ),
                                  )
                                );
                              }
                                }),
                      ),
                    ),
                  ),

                ],
              ),
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
                    style: getMainStyle(context)),
                actions: [
                  FlatButton(
                      onPressed: () {
                        servicePointRepository.remove(servicePoint);
                        Navigator.pop(context);
                      },
                      child: Text("Delete", style: getMainStyle(context))),
                  FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RequestCalendar(
                                      servicePoint: servicePoint,
                                    )));
                      },
                      child: Text("Calendar", style: getMainStyle(context)))
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
            Expanded(
              flex: 5,
              child: Container(
                child: Column(
                  children: [
                    Align(
                      child: Text(FlutterI18n.translate(context, "address") + ": " + servicePoint.address,
                          style: Theme.of(context).textTheme.headline1),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          FlutterI18n.translate(context, "count_of_stuff") +
                              ": " +
                              servicePoint.countOfStuff.toString(),
                          style: Theme.of(context).textTheme.headline1),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  children: [
                    FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RequestCalendar(
                                        servicePoint: servicePoint,
                                      )));
                        },
                        child: Icon(Icons.calendar_today, color: Colors.blueGrey)),
                    FlatButton(
                      child: Icon(Icons.delete, color: Colors.blueGrey),
                      onPressed: () {
                        servicePointRepository.remove(servicePoint);
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
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
}

TextStyle getMainStyle(context) {
  return Theme.of(context).textTheme.headline1;
}

AppBar getAppBar(String text, BuildContext context, {double scale = 1.5}) {
  return AppBar(
      title: Text(FlutterI18n.translate(context, text), textScaleFactor: scale),
      backgroundColor: Colors.black,
     );
}

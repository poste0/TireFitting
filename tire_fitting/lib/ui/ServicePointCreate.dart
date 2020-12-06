import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tire_fitting/data/ServicePointRepository.dart';
import 'package:tire_fitting/entity/ServicePoint.dart';
import 'file:///C:/TireFitting/tire_fitting/lib/main.dart';

class ServicePointCreate extends StatefulWidget {
  @override
  _ServicePointCreateState createState() => _ServicePointCreateState();
}

class _ServicePointCreateState extends State<ServicePointCreate> {
  var key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllers = _getTextEditingControllers();

    return Scaffold(
      appBar: getAppBar('create_service_point', context, scale: 1),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: key,
          child: Column(
            children: [
              _getAddressPartTextFormField('city', controllers[0]),
              _getAddressPartTextFormField('street', controllers[1]),
              _getAddressPartTextFormField('building', controllers[2]),
              TextFormField(
                decoration: InputDecoration(
                    labelText: FlutterI18n.translate(context, "count_of_stuff"),
                    labelStyle: Theme.of(context).textTheme.headline1),
                controller: controllers[3],
                keyboardType: TextInputType.number,
                validator: (value) {
                  return value.isEmpty ? FlutterI18n.translate(context, "enter_count_of_stuff") : null;
                },
              ),
              FlatButton(
                  onPressed: () {
                    List<String> value =
                        controllers.map((e) => e.text).toList();
                    if (key.currentState.validate()) {
                      String name = value[0] +
                          ", " +
                          value[1] +
                          ", " +
                          value[2];
                      ServicePointRepository().add(
                          ServicePoint(
                              address: name,
                              countOfStuff: int.parse(value[3])));
                      Navigator.pop(context, value);
                    }
                  },
                  child:
                      Text(FlutterI18n.translate(context, "ok"), style: Theme.of(context).textTheme.headline1)),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _getAddressPartTextFormField(
      String part, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: FlutterI18n.translate(context, part), labelStyle: Theme.of(context).textTheme.headline1),
      validator: (value) {
        return value.isEmpty ? FlutterI18n.translate(context, "enter_" + part) : null;
      },
    );
  }

  List<TextEditingController> _getTextEditingControllers() {
    List<TextEditingController> controllers = [];
    final fieldCount = 4;
    for (var i = 0; i < fieldCount; i++) {
      controllers.add(TextEditingController());
    }

    return controllers;
  }
}

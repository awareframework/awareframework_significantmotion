import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_significantmotion/awareframework_significantmotion.dart';
import 'package:awareframework_core/awareframework_core.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  SignificantMotionSensor sensor;
  SignificantMotionSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = SignificantMotionSensorConfig()
      ..debug = true;

    sensor = new SignificantMotionSensor(config);

    sensor.start();

  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: new SignificantMotionCard(sensor: sensor,)
      ),
    );
  }
}

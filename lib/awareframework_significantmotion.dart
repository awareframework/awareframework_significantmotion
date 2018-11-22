import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// init sensor
class SignificantMotionSensor extends AwareSensorCore {
  static const MethodChannel _significantMotionMethod = const MethodChannel('awareframework_significantmotion/method');
  static const EventChannel  _significantMotionStream  = const EventChannel('awareframework_significantmotion/event');

  static const EventChannel  _significantMotionStartStream  = const EventChannel("awareframework_significantmotion/event_on_significant_motion_start");
  static const EventChannel  _significantMotionEndStream  = const EventChannel("awareframework_significantmotion/event_on_significant_motion_end");

  /// Init Significantmotion Sensor with SignificantmotionSensorConfig
  SignificantMotionSensor(SignificantmotionSensorConfig config):this.convenience(config);
  SignificantMotionSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setSensorChannels(_significantMotionMethod, _significantMotionStream);
  }

  /// A sensor observer instance
  Stream<dynamic> get onSignificantMotionStart {
    return _significantMotionStartStream.receiveBroadcastStream(["on_significant_motion_start"]);
  }

  /// A sensor observer instance
  Stream<dynamic> get onSignificantMotionEnd {
    return _significantMotionEndStream.receiveBroadcastStream(["on_significant_motion_end"]);
  }
}

class SignificantmotionSensorConfig extends AwareSensorConfig{
  SignificantmotionSensorConfig();

  /// TODO

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class SignificantmotionCard extends StatefulWidget {
  SignificantmotionCard({Key key, @required this.sensor}) : super(key: key);

  SignificantMotionSensor sensor;

  @override
  SignificantmotionCardState createState() => new SignificantmotionCardState();
}


class SignificantmotionCardState extends State<SignificantmotionCard> {

  String status = "Status: ";

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onSignificantMotionStart.listen((event) {
      setState((){
        status = "Significant Motion Start";
      });
    });

    widget.sensor.onSignificantMotionEnd.listen((event) {
      setState((){
        status = "Significant Motion End";
      });
    });
    print(widget.sensor);
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: new Text(status),
        ),
      title: "Significantmotion",
      sensor: widget.sensor
    );
  }

}

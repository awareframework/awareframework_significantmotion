import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class SignificantMotionSensor extends AwareSensorCore {
  static const MethodChannel _significantMotionMethod =
    const MethodChannel('awareframework_significantmotion/method');

  static const EventChannel  _significantMotionStream  =
    const EventChannel('awareframework_significantmotion/event');

  static const EventChannel  _significantMotionStartStream =
    const EventChannel("awareframework_significantmotion/event_on_significant_motion_start");

  static const EventChannel  _significantMotionEndStream =
    const EventChannel("awareframework_significantmotion/event_on_significant_motion_end");

  SignificantMotionSensor(SignificantMotionSensorConfig config):this.convenience(config);
  SignificantMotionSensor.convenience(config) : super(config){
    super.setMethodChannel(_significantMotionMethod);
  }

  /// A sensor observer instance
  Stream<dynamic> get onSignificantMotionStart {
    return super.getBroadcastStream(
        _significantMotionStartStream, "on_significant_motion_start"
    );
  }

  /// A sensor observer instance
  Stream<dynamic> get onSignificantMotionEnd {
    return super.getBroadcastStream(
        _significantMotionEndStream, "on_significant_motion_end"
    );
  }

  @override
  void cancelAllEventChannels() {
    super.cancelBroadcastStream("on_significant_motion_start");
    super.cancelBroadcastStream("on_significant_motion_end");
  }
}

class SignificantMotionSensorConfig extends AwareSensorConfig{

  SignificantMotionSensorConfig();

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class SignificantMotionCard extends StatefulWidget {
  SignificantMotionCard({Key key, @required this.sensor}) : super(key: key);

  final SignificantMotionSensor sensor;

  @override
  SignificantMotionCardState createState() => new SignificantMotionCardState();
}


class SignificantMotionCardState extends State<SignificantMotionCard> {

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

  @override
  void dispose() {
    widget.sensor.cancelAllEventChannels();
    super.dispose();
  }

}

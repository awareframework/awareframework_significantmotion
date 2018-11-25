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
  SignificantMotionSensor(SignificantMotionSensorConfig config):this.convenience(config);
  SignificantMotionSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setMethodChannel(_significantMotionMethod);
  }

  /// A sensor observer instance
  Stream<dynamic> onSignificantMotionStart(String id) {
    return super.getBroadcastStream(_significantMotionStartStream, "on_significant_motion_start", id);
  }

  /// A sensor observer instance
  Stream<dynamic> onSignificantMotionEnd(String id) {
    return super.getBroadcastStream(_significantMotionEndStream, "on_significant_motion_end", id);
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
  SignificantMotionCard({Key key, @required this.sensor, this.cardId = "significant_motion_card"}) : super(key: key);

  SignificantMotionSensor sensor;
  String cardId;

  @override
  SignificantMotionCardState createState() => new SignificantMotionCardState();
}


class SignificantMotionCardState extends State<SignificantMotionCard> {

  String status = "Status: ";

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onSignificantMotionStart(widget.cardId+"_start").listen((event) {
      setState((){
        status = "Significant Motion Start";
      });
    });

    widget.sensor.onSignificantMotionEnd(widget.cardId+"_end").listen((event) {
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
    // TODO: implement dispose
    widget.sensor.cancelBroadcastStream(widget.cardId+"_start");
    widget.sensor.cancelBroadcastStream(widget.cardId+"_end");
    super.dispose();
  }

}

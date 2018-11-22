import Flutter
import UIKit
import SwiftyJSON
import com_awareframework_ios_sensor_significantmotion
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkSignificantmotionPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, SignificantMotionObserver{

    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                let json = JSON.init(config)
                self.significantMotionSensor = SignificantMotionSensor.init(SignificantMotionSensor.Config(json))
            }else{
                self.significantMotionSensor = SignificantMotionSensor.init(SignificantMotionSensor.Config())
            }
            self.significantMotionSensor?.CONFIG.sensorObserver = self
            return self.significantMotionSensor
        }else{
            return nil
        }
    }

    var significantMotionSensor:SignificantMotionSensor?

    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftAwareframeworkSignificantmotionPlugin()
        // add own channel
        super.setChannels(with: registrar,
                          instance: instance,
                          methodChannelName: "awareframework_significantmotion/method",
                          eventChannelName: "awareframework_significantmotion/event")

        let onStartStreamChannel = FlutterEventChannel.init(name: "awareframework_significantmotion/event_on_significant_motion_start", binaryMessenger: registrar.messenger())
        let onEndStreamChannel = FlutterEventChannel.init(name: "awareframework_significantmotion/event_on_significant_motion_end", binaryMessenger: registrar.messenger())
        
        onStartStreamChannel.setStreamHandler(instance)
        onEndStreamChannel.setStreamHandler(instance)
    }

    
    public func onSignificantMotionStart() {
        for handler in self.streamHandlers {
            if handler.eventName == "on_significant_motion_start" {
                handler.eventSink(nil)
            }
        }
    }
    
    public func onSignificantMotionEnd() {
        for handler in self.streamHandlers {
            if handler.eventName == "on_significant_motion_end" {
                handler.eventSink(nil)
            }
        }
    }
}

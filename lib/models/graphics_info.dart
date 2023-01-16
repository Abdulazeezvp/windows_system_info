import 'package:windows_system_info/models/gpu_controller.dart';
import 'package:windows_system_info/models/gpu_displays.dart';
import 'package:windows_system_info/models/windows_system_info.dart';

/// Graphics related information of device
class GraphicsInfo extends WindowsSystemInformation {
  @override
  List<Object?> get props => [controllers, displays];
  final List<Controller> controllers;
  final List<Display> displays;

  GraphicsInfo({
    required this.controllers,
    required this.displays,
  });

  ///convert from json return GraphicsInfo
  static GraphicsInfo fromJson(Map<String, dynamic> json) {
    return GraphicsInfo(
      controllers:
          json['graphics'] != null && json['graphics']['controllers'] != null
              ? Controller.fromJson(
                  Map<String, dynamic>.from(json['graphics']['controllers']))
              : [],
      displays: json['graphics'] != null && json['graphics']['displays'] != null
          ? Display.fromJson(
              Map<String, dynamic>.from(json['graphics']['displays']))
          : [],
    );
  }
}

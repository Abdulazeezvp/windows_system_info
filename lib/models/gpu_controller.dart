import 'package:windows_system_info/models/windows_system_info.dart';

/// graphics/ other controllers related information of device
class Controller extends WindowsSystemInformation {
  @override
  List<Object?> get props => [
        bus,
        model,
        vendor,
        vram,
        vramDynamic,
      ];

  final String bus;
  final String model;
  final String vendor;
  final double vram;
  final bool vramDynamic;

  /// Example:
  ///
  /// bus: "PCI"
  ///
  /// model: "Intel(R) HD Graphics"
  ///
  /// vendor: "Intel Corporation"
  ///
  /// vram: 3834.9140625
  ///
  /// vramDynamic: true
  ///
  Controller({
    required this.bus,
    required this.model,
    required this.vendor,
    required this.vram,
    required this.vramDynamic,
  });

  /// convert from json
  static List<Controller> fromJson(Map<String, dynamic> json) {
    //pass only controller Map
    List<Controller> controllerList = [];
    for (var i = 0; i < json.length; i++) {
      Controller controller = Controller(
        bus: json['$i']['bus'],
        model: json['$i']['model'],
        vendor: json['$i']['vendor'],
        vram: json['$i']['vram'],
        vramDynamic: json['$i']['vramDynamic'],
      );
      controllerList.add(controller);
    }
    return controllerList;
  }
}

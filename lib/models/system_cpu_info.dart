import 'package:windows_system_info/models/windows_system_info.dart';

/// system cpu information
class CpuInfo extends WindowsSystemInformation {
  @override
  List<Object?> get props => [
        brand,
        cores,
        family,
        manufacturer,
        model,
        physicalCores,
        revision,
        socket,
        speed,
        stepping,
        vendor,
      ];
  final String brand;
  final String cores;
  final String family;
  final String manufacturer;
  final String model;
  final String physicalCores;
  final String revision;
  final String socket;
  final String speed;
  final String stepping;
  final String vendor;

  /// brand: "Core™ i5 M 560"
  ///
  /// cores: "4"
  ///
  /// family: "6"
  ///
  /// manufacturer: "Intel®"
  ///
  /// model: "37"
  ///
  /// physicalCores: "2"
  ///
  /// processors: 1
  ///
  /// revision: ""
  ///
  /// socket: "CPU 1"
  ///
  /// speed: "2.67"
  ///
  /// stepping: "5"
  ///
  /// vendor: "GenuineIntel"
  ///
  CpuInfo({
    required this.brand,
    required this.cores,
    required this.family,
    required this.manufacturer,
    required this.model,
    required this.physicalCores,
    required this.revision,
    required this.socket,
    required this.speed,
    required this.stepping,
    required this.vendor,
  });
  static CpuInfo fromJson(Map<String, dynamic> json) {
    return CpuInfo(
      brand: json['brand'] ?? json['cpu'] != null && json['cpu']['Name'] != null
          ? json['cpu']['Name']
          : '',
      cores: json['cores'] ??
              json['cpu'] != null &&
                  json['cpu']['NumberOfLogicalProcessors'] != null
          ? json['cpu']['NumberOfLogicalProcessors']
          : '',
      family:
          json['family'] ?? json['cpu'] != null && json['cpu']['Family'] != null
              ? json['cpu']['Family']
              : '',
      manufacturer: json['manufacturer'] ??
              json['cpu'] != null && json['cpu']['Manufacturer'] != null
          ? json['cpu']['Manufacturer']
          : '',
      model:
          json['model'] ?? json['cpu'] != null && json['cpu']['Model'] != null
              ? json['cpu']['Model']
              : '',
      physicalCores: json['physicalCores'] ??
              json['cpu'] != null && json['cpu']['NumberOfCores'] != null
          ? json['cpu']['NumberOfCores']
          : '',
      revision: json['revision'] ??
              json['cpu'] != null && json['cpu']['Revision'] != null
          ? json['cpu']['Revision']
          : '',
      socket: json['socket'] ??
              json['cpu'] != null && json['cpu']['SocketDesignation'] != null
          ? json['cpu']['SocketDesignation']
          : '',
      speed: json['speed'] ??
              json['cpu'] != null && json['cpu']['MaxClockSpeed'] != null
          ? json['cpu']['MaxClockSpeed']
          : '',
      stepping: json['stepping'] ??
              json['cpu'] != null && json['cpu']['Stepping'] != null
          ? json['cpu']['Stepping']
          : '',
      vendor: json['vendor'] ??
              json['cpu'] != null && json['cpu']['Manufacturer'] != null
          ? json['cpu']['Manufacturer']
          : '',
    );
  }

  ///convert to json
  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'cores': cores,
      'family': family,
      'manufacturer': manufacturer,
      'model': model,
      'physicalCores': physicalCores,
      'revision': revision,
      'socket': socket,
      'speed': speed,
      'stepping': stepping,
      'vendor': vendor,
    };
  }
}

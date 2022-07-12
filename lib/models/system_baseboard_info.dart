import 'package:windows_system_info/models/windows_system_info.dart';

class BaseBoardInfo extends WindowsSystemInformation {
  ///base board information
  @override
  List<Object?> get props => [
        manufacturer,
        model,
        serial,
        version,
      ];
  final String manufacturer;
  final String model;
  final String serial;
  final String version;

  BaseBoardInfo({
    required this.manufacturer,
    required this.model,
    required this.serial,
    required this.version,
  });
  static BaseBoardInfo fromJson(Map<String, dynamic> json) {
    return BaseBoardInfo(
      manufacturer: json['manufacturer'] ??
              json['baseboard'] != null &&
                  json['baseboard']['Manufacturer'] != null
          ? json['baseboard']['Manufacturer']
          : '',
      model: json['model'] ??
              json['baseboard'] != null && json['baseboard']['Model'] != null
          ? json['baseboard']['Model']
          : '',
      serial: json['serial'] ??
              json['baseboard'] != null &&
                  json['baseboard']['SerialNumber'] != null
          ? json['baseboard']['SerialNumber']
          : '',
      version: json['version'] ??
              json['baseboard'] != null && json['baseboard']['Version'] != null
          ? json['baseboard']['Version']
          : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manufacturer': manufacturer,
      'model': model,
      'serial': serial,
      'version': version,
    };
  }
}

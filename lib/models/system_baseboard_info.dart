import 'package:windows_system_info/models/windows_system_info.dart';

///base board information
class BaseBoardInfo extends WindowsSystemInformation {
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

  /// manufacturer,
  ///
  /// model,
  ///
  /// serial,
  ///
  /// version,
  ///
  BaseBoardInfo({
    required this.manufacturer,
    required this.model,
    required this.serial,
    required this.version,
  });

  /// convert from json return BaseBoardInfo
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

import 'package:windows_system_info/models/windows_system_info.dart';

/// system chassis information, like manufacturer,type, model
class ChassisInfo extends WindowsSystemInformation {


  @override
  List<Object?> get props => [
        manufacturer,
        model,
        serial,
        sku,
        type,
        version,
      ];

  final String manufacturer;
  final String model;
  final String serial;
  final String sku;
  final String type;
  final String version;

  ///system chassis information
  ///
  /// manufacturer: ""
  /// 
  /// model: ""
  /// 
  /// serial: ""
  /// 
  /// sku: ""
  /// 
  /// type: "Laptop"
  /// 
  /// version: ""
  /// 
  ChassisInfo({
    required this.manufacturer,
    required this.model,
    required this.serial,
    required this.sku,
    required this.type,
    required this.version,
  });
  static ChassisInfo fromJson(Map<String, dynamic> json) {
    return ChassisInfo(
      manufacturer: json['manufacturer'] ??
              json['chassis'] != null && json['chassis']['Manufacturer'] != null
          ? json['chassis']['Manufacturer']
          : '',
      model: json['model'] ??
              json['chassis'] != null && json['chassis']['Model'] != null
          ? json['chassis']['Model']
          : '',
      serial: json['serial'] ??
              json['chassis'] != null && json['chassis']['SerialNumber'] != null
          ? json['chassis']['SerialNumber']
          : '',
      sku: json['sku'] ??
              json['chassis'] != null && json['chassis']['SKU'] != null
          ? json['chassis']['SKU']
          : '',
      type: json['type'] ??
              json['chassis'] != null && json['chassis']['ChassisTypes'] != null
          ? json['chassis']['ChassisTypes']
          : '',
      version: json['version'] ??
              json['chassis'] != null && json['chassis']['Version'] != null
          ? json['chassis']['Version']
          : '',
    );
  }

/// convert to json
  Map<String, dynamic> toJson() {
    return {
      'manufacturer': manufacturer,
      'model': model,
      'serial': serial,
      'sku': sku,
      'type': type,
      'version': version,
    };
  }
}

import 'package:windows_system_info/models/windows_system_info.dart';

class SystemInfo extends WindowsSystemInformation {
  ///model for windows system information like manufacturer,model, seriel,uuid etc...
  /// String manufacturer: "Dell ."
  /// String model: "Modelname Model Number"
  /// String serial: "unique value"
  /// String sku: ""
  /// String uuid: ""
  /// String version: "0001"
  //must add new properties inside props!!!
  @override
  List<Object?> get props => [
        manufacturer,
        model,
        serial,
        sku,
        uuid,
        version,
      ];

  final String manufacturer;
  final String model;
  final String serial;
  final String sku;
  final String uuid;
  final String version;

  SystemInfo({
    required this.manufacturer,
    required this.model,
    required this.serial,
    required this.sku,
    required this.uuid,
    required this.version,
  });
  static SystemInfo fromJson(Map<String, dynamic> json) {
    //must pass enitre json object created.
    //then using system and system sku
    return SystemInfo(
      manufacturer: json['manufacturer'] ??
              json['system'] != null && json['system']['Vendor'] != null
          ? json['system']['Vendor']
          : '',
      model: json['model'] ??
              json['system'] != null && json['system']['Name'] != null
          ? json['system']['Name']
          : '',
      serial: json['serial'] ??
              json['system'] != null &&
                  json['system']['IdentifyingNumber'] != null
          ? json['system']['IdentifyingNumber']
          : '',
      sku: json['sku'] ??
              json['systemSKU'] != null &&
                  json['systemSKU']['systemsku'] != null
          ? json['systemSKU']['systemsku']
          : '',
      uuid: json['uuid'] ??
              json['system'] != null && json['system']['UUID'] != null
          ? json['system']['UUID']
          : '',
      version: json['version'] ??
              json['system'] != null && json['system']['Version'] != null
          ? json['system']['Version']
          : '',
    );
  }

  Map<String, dynamic> toJson() {
    /// to json(Map<String,dynamic>) of model
    return {
      'manufacturer': manufacturer,
      'model': model,
      'serial': serial,
      'sku': sku,
      'uuid': uuid,
      'version': version,
    };
  }
}

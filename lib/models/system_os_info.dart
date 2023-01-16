import 'package:windows_system_info/models/windows_system_info.dart';

/// windows os information
class OsInfo extends WindowsSystemInformation {
  @override
  List<Object?> get props => [
        arch,
        build,
        distro,
        hostname,
        serial,
        uuid,
      ];

  final String arch;
  final String build;
  final String distro;
  final String hostname;
  final String serial;
  final String uuid;

  /// arch: "64-bit"
  ///
  /// build: "19043"
  ///
  /// distro: "Microsoft Windows 10 Home"
  ///
  /// hostname: "DESKTOP-ABCDEFG"
  ///
  /// serial: "xxxxx-xxxxx-xxxxx-xxxxx"
  OsInfo({
    required this.arch,
    required this.build,
    required this.distro,
    required this.hostname,
    required this.serial,
    required this.uuid,
  });

  static OsInfo fromJson(Map<String, dynamic> json) {
    return OsInfo(
        arch: json['arch'] ??
                json['os'] != null && json['os']['OSArchitecture'] != null
            ? json['os']['OSArchitecture']
            : '',
        build: json['build'] ??
                json['os'] != null && json['os']['BuildNumber'] != null
            ? json['os']['BuildNumber']
            : '',
        distro: json['distro'] ??
                json['os'] != null && json['os']['Caption'] != null
            ? json['os']['Caption']
            : '',
        hostname: json['hostname'] ??
                json['os'] != null && json['os']['CSName'] != null
            ? json['os']['CSName']
            : '',
        serial: json['serial'] ??
                json['os'] != null && json['os']['SerialNumber'] != null
            ? json['os']['SerialNumber']
            : '',
        uuid: json['uuid'] ??
                json['system'] != null && json['system']['UUID'] != null
            ? json['system']['UUID']
            : '');
  }

  /// to json(Map<String,dynamic>) of model
  Map<String, dynamic> toJson() {
    return {
      'arch': arch,
      'build': build,
      'distro': distro,
      'hostname': hostname,
      'serial': serial,
      'uuid': uuid,
    };
  }
}

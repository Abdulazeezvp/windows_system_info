import 'package:windows_system_info/models/windows_system_info.dart';

///bios information of system
class BiosInfo extends WindowsSystemInformation {
  @override
  List<Object?> get props => [
        releaseDate,
        vendor,
        version,
      ];
  final String releaseDate;
  final String vendor;
  final String version;

  /// releaseDate: "2011-02-15"
  ///
  /// vendor: "Dell Inc."
  ///
  /// version: "DELL - 000000"
  ///
  BiosInfo({
    required this.releaseDate,
    required this.vendor,
    required this.version,
  });

  static BiosInfo fromJson(Map<String, dynamic> json) {
    return BiosInfo(
      releaseDate: _formatRDate(json['releaseDate'] ?? json['bios'] != null
          ? json['bios']['ReleaseDate'].toString()
          : ''),
      vendor: json['vendor'] ??
              json['bios'] != null && json['bios']['Manufacturer'] != null
          ? json['bios']['Manufacturer']
          : '',
      version: json['version'] ??
              json['bios'] != null && json['bios']['Version'] != null
          ? json['bios']['Version']
          : '',
    );
  }

  static String _formatRDate(String date) {
    if (date.isNotEmpty && date.toLowerCase() != 'null' && date.length >= 8) {
      return '${date[0]}${date[1]}${date[2]}${date[3]}-${date[4]}${date[5]}-${date[6]}${date[7]}';
    }
    return '';
  }

  /// to json(Map<String,dynamic>) of model
  Map<String, dynamic> toJson() {
    return {
      'releaseDate': releaseDate,
      'vendor': vendor,
      'version': version,
    };
  }
}

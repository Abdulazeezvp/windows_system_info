import 'package:windows_system_info/models/windows_system_info.dart';

/// network related information fo device
class NetworkInfo extends WindowsSystemInformation {
  @override
  List<Object?> get props => [
        manufactruer,
        iface,
        ifaceName,
        mac,
        type,
        virtual,
      ];

  final String manufactruer;
  final String iface;
  final String ifaceName;
  final String mac;
  final String type;
  final bool virtual;

  /// manufactruer
  ///
  /// iface: "vEthernet (WSL)"
  ///
  /// ifaceName: "Hyper-V Virtual Ethernet Adapter"
  ///
  /// mac: "00:00:00:a0:00:d0"
  ///
  /// type: "wired"
  ///
  /// virtual: true
  ///
  NetworkInfo({
    required this.manufactruer,
    required this.iface,
    required this.ifaceName,
    required this.mac,
    required this.type,
    required this.virtual,
  });

  /// convert from json return List of NetworkInfo
  static List<NetworkInfo> fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> network = json['net'] ?? {};
    List<NetworkInfo> networkList = [];
    for (var i = 1; i <= network.length; i++) {
      NetworkInfo net = NetworkInfo(
        manufactruer: network['$i']['Manufacturer'] ?? '',
        iface: network['$i']['NetConnectionID'] ?? '',
        ifaceName: network['$i']['Name'] ?? '',
        mac: network['$i']['MACAddress'] ?? '',
        type: network['$i']['type'] ?? '',
        virtual:
            network['$i']['PhysicalAdapter'].toString().toLowerCase() == 'true'
                ? true
                : false,
      );
      networkList.add(net);
    }
    return networkList;
  }
}

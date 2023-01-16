import 'package:windows_system_info/models/disk_layout_info.dart';
import 'package:windows_system_info/models/graphics_info.dart';
import 'package:windows_system_info/models/memory_info.dart';
import 'package:windows_system_info/models/network_info.dart';
import 'package:windows_system_info/models/system_baseboard_info.dart';
import 'package:windows_system_info/models/system_chassis_info.dart';
import 'package:windows_system_info/models/system_cpu_info.dart';
import 'package:windows_system_info/models/system_info.dart';
import 'package:windows_system_info/models/system_os_info.dart';
import 'package:windows_system_info/models/systrem_bios_info.dart';
import 'package:windows_system_info/models/windows_system_info.dart';

/// all information about windows system includes static and non static values
class AllInfo extends WindowsSystemInformation {
  @override
  List<Object?> get props => [
        system,
        bios,
        baseBoard,
        chassis,
        os,
        cpu,
        network,
        disks,
        memories,
        graphicsInfo,
      ];

  final SystemInfo system;
  final BiosInfo bios;
  final BaseBoardInfo baseBoard;
  final ChassisInfo chassis;
  final OsInfo os;
  final CpuInfo cpu;
  final List<NetworkInfo> network;
  final List<DiskLayoutInfo> disks;
  final List<MemoryInfo> memories;
  final GraphicsInfo graphicsInfo;

  /// {system,
  ///
  ///  bios,
  ///
  ///  baseBoard,
  ///
  ///  chassis,
  ///
  ///  os,
  ///
  ///  cpu,
  ///
  ///  network,
  ///
  ///  disks,
  ///
  ///  memories,
  ///
  ///  graphicsInfo
  ///
  /// }
  AllInfo({
    required this.system,
    required this.bios,
    required this.baseBoard,
    required this.chassis,
    required this.os,
    required this.cpu,
    required this.network,
    required this.disks,
    required this.memories,
    required this.graphicsInfo,
  });

  /// convert from json
  static AllInfo fromJson(Map<String, dynamic> json) {
    return AllInfo(
      system: SystemInfo.fromJson(json),
      bios: BiosInfo.fromJson(json),
      baseBoard: BaseBoardInfo.fromJson(json),
      chassis: ChassisInfo.fromJson(json),
      os: OsInfo.fromJson(json),
      cpu: CpuInfo.fromJson(json),
      network: NetworkInfo.fromJson(json),
      disks: DiskLayoutInfo.fromJson(json),
      memories: MemoryInfo.fromJson(json),
      graphicsInfo: GraphicsInfo.fromJson(json),
    );
  }
}

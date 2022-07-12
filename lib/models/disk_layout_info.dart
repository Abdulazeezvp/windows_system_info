import 'package:windows_system_info/models/windows_system_info.dart';

class DiskLayoutInfo extends WindowsSystemInformation {
  @override
  List<Object?> get props => [
        bytesPerSector,
        device,
        firmwareRevision,
        interfaceType,
        name,
        sectorsPerTrack,
        serialNum,
        size,
        smartStatus,
        totalCylinders,
        totalHeads,
        totalSectors,
        totalTracks,
        tracksPerCylinder,
        type,
      ];

  /// example values::
  /// bytesPerSector: 512
  /// device: ""
  /// firmwareRevision: ""
  /// interfaceType: "RAID"
  /// name: ""
  /// sectorsPerTrack: 63
  /// serialNum: ""
  /// size: 240054796800
  /// smartStatus: "Ok"
  /// totalCylinders: 29185
  /// totalHeads: 255
  /// totalSectors: 468857025
  /// totalTracks: 7442175
  /// tracksPerCylinder: 255
  /// type: "SSD"

  final int bytesPerSector;
  final String device;
  final String firmwareRevision;
  final String interfaceType;
  final String name;
  final int sectorsPerTrack;
  final String serialNum;
  final int size;
  final String smartStatus;
  final int totalCylinders;
  final int totalHeads;
  final int totalSectors;
  final int totalTracks;
  final int tracksPerCylinder;
  final String type;

  DiskLayoutInfo({
    required this.bytesPerSector,
    required this.device,
    required this.firmwareRevision,
    required this.interfaceType,
    required this.name,
    required this.sectorsPerTrack,
    required this.serialNum,
    required this.size,
    required this.smartStatus,
    required this.totalCylinders,
    required this.totalHeads,
    required this.totalSectors,
    required this.totalTracks,
    required this.tracksPerCylinder,
    required this.type,
  });

  static List<DiskLayoutInfo> fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> diskLayoutData = json['disklayout'] ?? {};
    List<DiskLayoutInfo> diskLayoutList = [];
    if (diskLayoutData.isNotEmpty) {
      for (var i = 0; i < diskLayoutData.length; i++) {
        DiskLayoutInfo disk = DiskLayoutInfo(
          bytesPerSector:
              int.tryParse(diskLayoutData['$i']['BytesPerSector'].toString()) ??
                  0,
          device: "",
          firmwareRevision: diskLayoutData['$i']['FirmwareRevision'],
          interfaceType: diskLayoutData['$i']['BusType'],
          name: diskLayoutData['$i']['Caption'],
          sectorsPerTrack: int.tryParse(
                  diskLayoutData['$i']['SectorsPerTrack'].toString()) ??
              0,
          serialNum: diskLayoutData['$i']['SerialNumber'],
          size: int.tryParse(diskLayoutData['$i']['Size'].toString()) ?? 0,
          smartStatus: diskLayoutData['$i']['Status'],
          totalCylinders:
              int.tryParse(diskLayoutData['$i']['TotalCylinders'].toString()) ??
                  0,
          totalHeads:
              int.tryParse(diskLayoutData['$i']['TotalHeads'].toString()) ?? 0,
          totalSectors:
              int.tryParse(diskLayoutData['$i']['TotalSectors'].toString()) ??
                  0,
          totalTracks:
              int.tryParse(diskLayoutData['$i']['TotalTracks'].toString()) ?? 0,
          tracksPerCylinder: int.tryParse(
                  diskLayoutData['$i']['TracksPerCylinder'].toString()) ??
              0,
          type: diskLayoutData['$i']['MediaType'],
        );

        diskLayoutList.add(disk);
      }
    }
    return diskLayoutList;
  }
}

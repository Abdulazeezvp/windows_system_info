import 'package:windows_system_info/models/all_info.dart';
import 'package:windows_system_info/models/windows_system_info.dart';

class DeviceStaticinfo extends WindowsSystemInformation {
  @override
  List<Object?> get props => [
        systemManufacturer,
        systemModel,
        systemSerial,
        systemUuid,
        biosVendor,
        biosVersion,
        biosReleaseDate,
        baseboardManufacturer,
        baseboardModel,
        baseboardSerial,
        chassisManufacturer,
        chassisModel,
        chassisType,
        chassisSerial,
        osPlatform,
        osDistro,
        osRelease,
        osArch,
        osHostname,
        osBuild,
        osKernal,
        osSerial,
        uuidOs,
        cpuManufacturer,
        cpuBrand,
        cpuSpeed,
        cpuCores,
        cpuPhysicalCores,
        cpuVendor,
        cpuSocket,
      ];

  ///model for static information of device, assuming this information
  ///will not change without replacing or resetting pc.

  final String systemManufacturer;
  final String systemModel;
  final String systemSerial;
  final String systemUuid;
  final String biosVendor;
  final String biosVersion;
  final String biosReleaseDate;
  final String baseboardManufacturer;
  final String baseboardModel;
  final String baseboardSerial;
  final String chassisManufacturer;
  final String chassisModel;
  final String chassisType;
  final String chassisSerial;
  final String osPlatform;
  final String osDistro;
  final String osRelease;
  final String osArch;
  final String osHostname;
  final String osBuild;
  final String osKernal;
  final String osSerial;
  final String uuidOs;
  final String cpuManufacturer;
  final String cpuBrand;
  final String cpuSpeed;
  final String cpuCores;
  final String cpuPhysicalCores;
  final String cpuVendor;
  final String cpuSocket;

  DeviceStaticinfo({
    required this.systemManufacturer,
    required this.systemModel,
    required this.systemSerial,
    required this.systemUuid,
    required this.biosVendor,
    required this.biosVersion,
    required this.biosReleaseDate,
    required this.baseboardManufacturer,
    required this.baseboardModel,
    required this.baseboardSerial,
    required this.chassisManufacturer,
    required this.chassisModel,
    required this.chassisType,
    required this.chassisSerial,
    required this.osPlatform,
    required this.osDistro,
    required this.osRelease,
    required this.osArch,
    required this.osHostname,
    required this.osBuild,
    required this.osKernal,
    required this.osSerial,
    required this.uuidOs,
    required this.cpuManufacturer,
    required this.cpuBrand,
    required this.cpuSpeed,
    required this.cpuCores,
    required this.cpuPhysicalCores,
    required this.cpuVendor,
    required this.cpuSocket,
  });

  static DeviceStaticinfo fromAllInfo(AllInfo allInfo) {
    return DeviceStaticinfo(
      systemManufacturer: allInfo.system.manufacturer,
      systemModel: allInfo.system.model,
      systemSerial: allInfo.system.serial,
      systemUuid: allInfo.system.uuid,
      biosVendor: allInfo.bios.vendor,

      ///posiblity for change in details so keeping as empty String
      biosVersion: '',
      biosReleaseDate: allInfo.bios.releaseDate,
      baseboardManufacturer: allInfo.baseBoard.manufacturer,
      baseboardModel: allInfo.baseBoard.model,
      baseboardSerial: allInfo.baseBoard.serial,
      chassisManufacturer: allInfo.chassis.manufacturer,
      chassisModel: allInfo.chassis.model,
      chassisType: allInfo.chassis.type,
      chassisSerial: allInfo.chassis.serial,

      ///will change if new product purchased and upgraded
      osPlatform: allInfo.os.distro.contains('11')
          ? 'Windows 11'
          : allInfo.os.distro.contains('10')
              ? 'Windows 10'
              : allInfo.os.distro.contains('8')
                  ? 'Windows 8'
                  : allInfo.os.distro.contains('7')
                      ? 'Windows 7'
                      : allInfo.os.distro,
      osDistro: allInfo.os.distro,
      osRelease: '',
      osArch: allInfo.os.arch,
      osHostname: allInfo.os.hostname,
      osBuild: allInfo.os.build,
      osKernal: '',
      osSerial: allInfo.os.serial,
      uuidOs: allInfo.os.uuid,
      cpuManufacturer: allInfo.cpu.manufacturer,
      cpuBrand: allInfo.cpu.brand,
      cpuSpeed: allInfo.cpu.speed,
      cpuCores: allInfo.cpu.cores,
      cpuPhysicalCores: allInfo.cpu.physicalCores,
      cpuVendor: allInfo.cpu.vendor,
      cpuSocket: allInfo.cpu.socket,
    );
  }
}

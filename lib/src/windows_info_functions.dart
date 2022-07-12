import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:windows_system_info/models/all_info.dart';
import 'package:windows_system_info/models/static_info.dart';
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
import 'package:windows_system_info/src/general_helper.dart';

class WindowsSystemInfo {
  static AllInfo? _windowsSystemAllInfo;
  static DeviceStaticinfo? _staticSystemInfo;
  static bool _isInitlizPending = false;
  static String _systemUserName = '';

  ///must call function before using all getter methods,
  ///and run initilise when ever fetched data need to be updated.
  static Future<void> initWindowsInfo() async {
    if (Platform.isWindows && _isInitlizPending == false) {
      _isInitlizPending = true;
      Map<String, dynamic> deviceInfo =
          await compute(_getValueFromPowerShell, '');
      AllInfo wsAllInfo = AllInfo.fromJson(deviceInfo);
      _windowsSystemAllInfo = wsAllInfo;
      _staticSystemInfo = DeviceStaticinfo.fromAllInfo(wsAllInfo);
      _systemUserName = deviceInfo['userName'];
      _isInitlizPending = false;
    } else {
      _isInitlizPending
          ? throw ErrorHint('windows info: Concurrent init calls')
          : throw UnsupportedError('Not windows');
    }
  }

  ///get system userprofile name
  ///
  ///eg: Test123 from DESKTOP-454545J/Test123
  ///
  static String get userName {
    return _systemUserName.split('\\').last;
  }

  ///will get null if not intilsed,
  /// will get complete info of windows device
  static AllInfo? get windowsSystemInformation {
    return _windowsSystemAllInfo;
  }

  ///will return static info of windows device and null if not intilsed;
  static DeviceStaticinfo? get windowsSystemStaticInformation {
    return _staticSystemInfo;
  }

  ///will return device name
  ///
  ///eg: DESKTOP-454545J from DESKTOP-454545J/Test123
  static String get deviceName {
    return _windowsSystemAllInfo?.os.hostname ?? '';
  }

  ///will return true if 64 based os installed
  static bool get is64bit {
    return _windowsSystemAllInfo != null &&
        _windowsSystemAllInfo!.os.arch.toString().contains('64');
  }

  /// will return true if 32 based os installed
  static bool get is32bit {
    return (_windowsSystemAllInfo != null &&
        (_windowsSystemAllInfo!.os.arch.contains('32') ||
            _windowsSystemAllInfo!.os.arch.contains('86')));
  }

  ///will return true if inilising in progress else false
  static bool get isInitInProgress {
    return _isInitlizPending;
  }

  ///will return true if data intilised, wait to complete last init
  static Future<bool> get isInitilized async {
    await GeneralHelper.waitWhile(() => _isInitlizPending);
    return _isInitlizPending == false &&
        _windowsSystemAllInfo != null &&
        _staticSystemInfo != null;
  }

  ///will return all disks attached to device,
  ///
  ///empty array in case of null
  static List<DiskLayoutInfo> get disks {
    return _windowsSystemAllInfo?.disks ?? [];
  }

  ///will return all grahpics relted details,
  ///
  ///include controller(generally grahpics card info) and displays.
  ///
  ///null incase if not intilsed
  static GraphicsInfo? get graphics {
    return _windowsSystemAllInfo?.graphicsInfo;
  }

  ///will return all primary memory information in pc,
  ///
  ///return empty List in case of null
  static List<MemoryInfo> get memories {
    return _windowsSystemAllInfo?.memories ?? [];
  }

  ///will return all network details,empty array incase of null
  static List<NetworkInfo> get network {
    return _windowsSystemAllInfo?.network ?? [];
  }

  ///will return all baseboard details
  static BaseBoardInfo? get baseBoard {
    return _windowsSystemAllInfo?.baseBoard;
  }

  ///will return all chassis details,
  static ChassisInfo? get chassis {
    return _windowsSystemAllInfo?.chassis;
  }

  ///will return all cpu related details
  static CpuInfo? get cpu {
    return _windowsSystemAllInfo?.cpu;
  }

  ///will return systen info
  static SystemInfo? get system {
    return _windowsSystemAllInfo?.system;
  }

  ///will return Operating system details
  static OsInfo? get os {
    return _windowsSystemAllInfo?.os;
  }

  ///will return bios details
  static BiosInfo? get bios {
    return _windowsSystemAllInfo?.bios;
  }

  static Map<String, dynamic> _getValueFromPowerShell(String _) {
    Map<String, dynamic> deviceInfo = {};

    ///username
    deviceInfo['userName'] =
        GeneralHelper.powerShell('\$env:USERPROFILE').split('\\').last;
    //CMD: echo %USERPROFILE%

    ///system related information
    ///Name
    ///Vendor
    ///Version
    ///IdentifyingNumber
    ///UUID
    ///virtual
    ///virtualHost
    deviceInfo['system'] = GeneralHelper.formatSystemInfo(
      GeneralHelper.getValueAsMap(
          data: GeneralHelper.powerShell(
              'Get-WmiObject Win32_ComputerSystemProduct | select Name,Vendor,Version,IdentifyingNumber,UUID | fl'),
          seprator: ':'),
    );
    //CMD: WMIC /namespace:\\root\cimv2 path Win32_ComputerSystemProduct GET Name,Vendor,Version,IdentifyingNumber,UUID /format:list

    ///system related information
    ///systemsku
    deviceInfo['systemSKU'] = GeneralHelper.getValueAsMap(
        data: GeneralHelper.powerShell(
            'Get-WmiObject MS_Systeminformation -Namespace "root/wmi" | select systemsku | fl'),
        seprator: ':');
    //CMD: WMIC /namespace:\\root\wmi path MS_Systeminformation GET systemsku /format:list

    ///system related information bios info
    ///Description
    ///Version
    ///Manufacturer
    ///ReleaseDate
    ///BuildNumber
    ///SerialNumber
    deviceInfo['bios'] = GeneralHelper.getValueAsMap(
        data: GeneralHelper.powerShell(
            'Get-WmiObject Win32_bios | select Description,Version,Manufacturer,ReleaseDate,BuildNumber,SerialNumber | fl'),
        seprator: ':');
    //CMD: WMIC /namespace:\\root\cimv2 path Win32_bios GET Description,Version,Manufacturer,ReleaseDate,BuildNumber,SerialNumber /format:list

    ///system related information
    ///Manufacturer
    ///Model
    ///SerialNumber
    ///Version
    deviceInfo['baseboard'] = GeneralHelper.getValueAsMap(
        data: GeneralHelper.powerShell(
            'Get-WmiObject Win32_BaseBoard | select Manufacturer,Model,SerialNumber,Version | fl'),
        seprator: ':');
    // CMD: WMIC /namespace:\\root\cimv2 path Win32_BaseBoard GET Manufacturer,Model,SerialNumber,Version /format:list

    ///system related information
    ///Model
    ///Manufacturer
    ///ChassisTypes
    ///Version
    ///SerialNumber
    ///PartNumber
    ///SKU
    deviceInfo['chassis'] = GeneralHelper.formatChassis(
      GeneralHelper.getValueAsMap(
        data: GeneralHelper.powerShell(
            'Get-WmiObject Win32_SystemEnclosure | select Model,Manufacturer,ChassisTypes,Version,SerialNumber,PartNumber,SKU | fl'),
        seprator: ':',
      ),
    );
    //CMD: WMIC /namespace:\\root\cimv2 path Win32_SystemEnclosure GET Model,Manufacturer,ChassisTypes,Version,SerialNumber,PartNumber,SKU /format:list

    ///os related information
    ///BuildNumber
    ///Caption
    ///CSName
    ///OSArchitecture
    ///SerialNumber
    deviceInfo['os'] = GeneralHelper.getValueAsMap(
      data: GeneralHelper.powerShell(
          'Get-WmiObject Win32_OperatingSystem | select BuildNumber,Caption,CSName,OSArchitecture,SerialNumber | fl'),
      seprator: ':',
    );
    //CMD: WMIC /namespace:\\root\cimv2 path Win32_OperatingSystem GET BuildNumber,Caption,CSName,OSArchitecture,SerialNumber /format:list

    ///cpu information:processor and other details
    ///Description
    ///Manufacturer
    ///MaxClockSpeed
    ///Name
    ///NumberOfCores
    ///SocketDesignation
    ///NumberOfLogicalProcessors
    ///L2CacheSize
    ///L3CacheSize
    ///Revision
    ///Family
    ///Model
    ///Stepping
    deviceInfo['cpu'] = GeneralHelper.getValueAsMap(
      data: GeneralHelper.powerShell(
          'Get-WmiObject Win32_Processor | select Description,Manufacturer,MaxClockSpeed,Name,NumberOfCores,SocketDesignation,NumberOfLogicalProcessors,L2CacheSize,L3CacheSize,Revision | fl'),
      seprator: ':',
    );
    //CMD: WMIC /namespace:\\root\cimv2 path Win32_Processor GET Description,Manufacturer,MaxClockSpeed,Name,NumberOfCores,SocketDesignation,NumberOfLogicalProcessors,L2CacheSize,L3CacheSize,Revision /format:list

    ///network:without ip address:from dll of windows
    ///Name
    ///Manufacturer
    ///MACAddress
    ///PhysicalAdapter
    ///NetConnectionID
    ///type
    deviceInfo['net'] = GeneralHelper.formatNetworkDetailsdata(
      GeneralHelper.getValueAsMap(
        data: GeneralHelper.powerShell(
            'Get-WmiObject Win32_NetworkAdapter | select Name,Manufacturer,MACAddress,PhysicalAdapter,NetConnectionID | fl'),
        seprator: ':',
        isList: true,
      ),
    );
    //CMD: WMIC /namespace:\\root\cimv2 path Win32_NetworkAdapter GET Name,Manufacturer,MACAddress,PhysicalAdapter,NetConnectionID /format:list

    ///disk layout:all hdd & ssd connected to pc
    ///Caption
    ///Size
    ///Status
    ///PNPDeviceId
    ///BytesPerSector
    ///TotalCylinders
    ///TotalHeads
    ///TotalSectors
    ///TotalTracks
    ///TracksPerCylinder
    ///SectorsPerTrack
    ///FirmwareRevision
    ///SerialNumber
    ///InterfaceType
    ///BusType
    ///MediaType
    ///FriendlyName
    ///Model
    ///SerialNumber
    ///Size
    deviceInfo['disklayout'] = GeneralHelper.formatDiskLayout(
      GeneralHelper.getValueAsMap(
        data: GeneralHelper.powerShell(
            'Get-WmiObject Win32_DiskDrive | select Caption,Size,Status,PNPDeviceId,BytesPerSector,TotalCylinders,TotalHeads,TotalSectors,TotalTracks,TracksPerCylinder,SectorsPerTrack,FirmwareRevision,SerialNumber,InterfaceType | fl'),
        seprator: ':',
        isList: true,
      ),
      GeneralHelper.getValueAsMap(
        data: GeneralHelper.powerShell(
            'Get-PhysicalDisk | select BusType,MediaType,FriendlyName,Model,SerialNumber,Size | fl'),
        seprator: ':',
        isList: true,
      ),
    );
    //CMD: WMIC /namespace:\\root\cimv2 path Win32_DiskDrive GET Caption,Size,Status,PNPDeviceId,BytesPerSector,TotalCylinders,TotalHeads,TotalSectors,TotalTracks,TracksPerCylinder,SectorsPerTrack,FirmwareRevision,SerialNumber,InterfaceType /format:list
    //CMD: WMIC diskdrive GET MediaType,Model,SerialNumber,Size /format:list --need to be verified its working good

    ///memory layout:
    ///DataWidth
    ///TotalWidth
    ///Capacity
    ///BankLabel
    ///MemoryType
    ///SMBIOSMemoryType
    ///ConfiguredClockSpeed
    ///FormFactor
    ///Manufacturer
    ///PartNumber
    ///SerialNumber
    ///ConfiguredVoltage
    ///MinVoltage
    ///MaxVoltage
    deviceInfo['memlayout'] = GeneralHelper.formatMemoryLayout(
      GeneralHelper.getValueAsMap(
        data: GeneralHelper.powerShell(
            'Get-WmiObject Win32_PhysicalMemory | select DataWidth,TotalWidth,Capacity,BankLabel,MemoryType,SMBIOSMemoryType,ConfiguredClockSpeed,FormFactor,Manufacturer,PartNumber,SerialNumber,ConfiguredVoltage,MinVoltage,MaxVoltage | fl'),
        seprator: ':',
        isList: true,
      ),
    );
    //CMD: WMIC /namespace:\\root\cimv2 path Win32_PhysicalMemory GET DataWidth,TotalWidth,Capacity,BankLabel,MemoryType,SMBIOSMemoryType,ConfiguredClockSpeed,FormFactor,Manufacturer,PartNumber,SerialNumber,ConfiguredVoltage,MinVoltage,MaxVoltage /format:list

    ///graphics data
    ///--controllers(details of gpu)
    ///model
    ///bus
    ///vendor
    ///vram
    ///vramDynamic
    ///--displays(details of display)
    ///bulletin
    ///connection
    ///pixelDepth
    ///vendor
    ///model
    ///main
    ///resolutionX
    ///resolutionY
    ///sizeX
    ///sizeY
    ///currentResX
    ///currentResY
    ///positionX
    ///positionY
    deviceInfo['graphics'] = GeneralHelper.formatGraphics(
      videoControllerData: GeneralHelper.getValueAsMap(
        data: GeneralHelper.powerShell(
            'Get-WmiObject win32_VideoController | fl *'),
        seprator: ':',
        isList: true,
      ),
      dSectionData: GeneralHelper.getValueAsMap(
        data: GeneralHelper.powerShell(
            'Get-WmiObject win32_desktopmonitor | fl *'),
        seprator: ':',
        isList: true,
      ),
      basicDisplayParamsData: GeneralHelper.getValueAsMap(
          data: GeneralHelper.powerShell(
              'Get-CimInstance -Namespace root\\WMI -ClassName WmiMonitorBasicDisplayParams | fl'),
          seprator: ':',
          isList: true),
      monitorConnectionparameters: GeneralHelper.getValueAsMap(
          data: GeneralHelper.powerShell(
              'Get-CimInstance -Namespace root\\WMI -ClassName WmiMonitorConnectionParams | fl'),
          seprator: ':',
          isList: true),
      formsDataAllScreens: GeneralHelper.getValueAsMap(
        data: GeneralHelper.powerShell(
            'Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Screen]::AllScreens'),
        seprator: ':',
        isList: true,
      ),
    );

    // CMD: WMIC /namespace:\\root\cimv2 path win32_VideoController GET * /format:list
    // CMD: WMIC /namespace:\\root\cimv2 path win32_desktopmonitor GET * /format:list
    // CMD: WMIC /namespace:\\root\WMI path WmiMonitorBasicDisplayParams GET * /format:list
    // CMD: WMIC /namespace:\\root\WMI path WmiMonitorConnectionParams GET * /format:list
    // CMD: --need to find out.
    return deviceInfo;
  }
}

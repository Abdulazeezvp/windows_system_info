import 'dart:async';
import 'dart:convert';
import 'dart:io';

class GeneralHelper {
  ///powershell command:cmd command
  static final Map<String, String> _aCmd = {
    //bios
    "Get-WmiObject Win32_bios | select Version, SerialNumber, SMBIOSBIOSVersion":
        "WMIC /namespace:\\\root\\cimv2 path Win32_bios GET Version,SerialNumber,SMBIOSBIOSVersion /format:list",
    //system
    "Get-WmiObject Win32_ComputerSystemProduct | select Name,Vendor,Version,IdentifyingNumber,UUID | fl":
        "WMIC /namespace:\\\root\\cimv2 path Win32_ComputerSystemProduct GET Name,Vendor,Version,IdentifyingNumber,UUID /format:list",
    //system sku
    'Get-WmiObject MS_Systeminformation -Namespace "root/wmi" | select systemsku | fl':
        "WMIC /namespace:\\\root\\wmi path MS_Systeminformation GET systemsku /format:list",
    //bios-before checking virtual
    "Get-WmiObject Win32_bios | select Description,Version,Manufacturer,ReleaseDate,BuildNumber,SerialNumber | fl":
        "WMIC /namespace:\\\root\\cimv2 path Win32_bios GET Description,Version,Manufacturer,ReleaseDate,BuildNumber,SerialNumber /format:list",
    // baseboard
    "Get-WmiObject Win32_BaseBoard | select Manufacturer,Model,SerialNumber,Version | fl":
        "WMIC /namespace:\\\root\\cimv2 path Win32_BaseBoard GET Manufacturer,Model,SerialNumber,Version /format:list",
    // chassis
    "Get-WmiObject Win32_SystemEnclosure | select Model,Manufacturer,ChassisTypes,Version,SerialNumber,PartNumber,SKU | fl":
        "WMIC /namespace:\\\root\\cimv2 path Win32_SystemEnclosure GET Model,Manufacturer,ChassisTypes,Version,SerialNumber,PartNumber,SKU /format:list",
    // os
    "Get-WmiObject Win32_OperatingSystem | select BuildNumber,Caption,CSName,OSArchitecture,SerialNumber | fl":
        "WMIC /namespace:\\\root\\cimv2 path Win32_OperatingSystem GET BuildNumber,Caption,CSName,OSArchitecture,SerialNumber /format:list",
    // cpu
    "Get-WmiObject Win32_Processor | select Description,Manufacturer,MaxClockSpeed,Name,NumberOfCores,SocketDesignation,NumberOfLogicalProcessors,L2CacheSize,L3CacheSize,Revision | fl":
        "WMIC /namespace:\\\root\\cimv2 path Win32_Processor GET Description,Manufacturer,MaxClockSpeed,Name,NumberOfCores,SocketDesignation,NumberOfLogicalProcessors,L2CacheSize,L3CacheSize,Revision /format:list",
    // net
    "Get-WmiObject Win32_NetworkAdapter | select Name,Manufacturer,MACAddress,PhysicalAdapter,NetConnectionID | fl":
        "WMIC /namespace:\\\root\\cimv2 path Win32_NetworkAdapter GET Name,Manufacturer,MACAddress,PhysicalAdapter,NetConnectionID /format:list",
    // disklayout
    "Get-WmiObject Win32_DiskDrive | select Caption,Size,Status,PNPDeviceId,BytesPerSector,TotalCylinders,TotalHeads,TotalSectors,TotalTracks,TracksPerCylinder,SectorsPerTrack,FirmwareRevision,SerialNumber,InterfaceType | fl":
        "WMIC /namespace:\\\root\\cimv2 path Win32_DiskDrive GET Caption,Size,Status,PNPDeviceId,BytesPerSector,TotalCylinders,TotalHeads,TotalSectors,TotalTracks,TracksPerCylinder,SectorsPerTrack,FirmwareRevision,SerialNumber,InterfaceType /format:list",
    "Get-PhysicalDisk | select BusType,MediaType,FriendlyName,Model,SerialNumber,Size | fl":
        "WMIC diskdrive GET MediaType,Model,SerialNumber,Size /format:list",
    // mem layout
    "Get-WmiObject Win32_PhysicalMemory | select DataWidth,TotalWidth,Capacity,BankLabel,MemoryType,SMBIOSMemoryType,ConfiguredClockSpeed,FormFactor,Manufacturer,PartNumber,SerialNumber,ConfiguredVoltage,MinVoltage,MaxVoltage | fl":
        "WMIC /namespace:\\\root\\cimv2 path Win32_PhysicalMemory GET DataWidth,TotalWidth,Capacity,BankLabel,MemoryType,SMBIOSMemoryType,ConfiguredClockSpeed,FormFactor,Manufacturer,PartNumber,SerialNumber,ConfiguredVoltage,MinVoltage,MaxVoltage /format:list",
    // graphics
    "Get-WmiObject win32_VideoController | fl *":
        "WMIC /namespace:\\\root\\cimv2 path win32_VideoController GET * /format:list",
    "Get-WmiObject win32_desktopmonitor | fl *":
        "WMIC /namespace:\\\root\\cimv2 path win32_desktopmonitor GET * /format:list",
    "Get-CimInstance -Namespace root\\WMI -ClassName WmiMonitorBasicDisplayParams | fl":
        "WMIC /namespace:\\\root\\WMI path WmiMonitorBasicDisplayParams GET * /format:list",
    "Get-CimInstance -Namespace root\\WMI -ClassName WmiMonitorConnectionParams | fl":
        "WMIC /namespace:\\\root\\WMI path WmiMonitorConnectionParams GET * /format:list",
    //username
    "\$env:USERPROFILE": "echo %USERPROFILE%"
  };

  ///return Map/List[Map] of String
  ///
  ///Map will return for normal values
  ///
  ///List will return if "iSList" set to true
  ///
  static dynamic getValueAsMap({
    required String data,
    required String seprator,
    bool isList = false,
  }) {
    final arrayOfString = const LineSplitter().convert(data);
    Map<String, dynamic> valueMap = {};
    List<Map<String, dynamic>> valueList = [{}];
    int itemNumber = 0;
    for (String string in arrayOfString) {
      var keyValue = string.split(seprator);
      String key;
      String value;
      if (keyValue.isNotEmpty) {
        key = keyValue[0].trim();
        keyValue.removeAt(0);
        if (keyValue.isNotEmpty) {
          value = keyValue
              .map((e) => e.trim())
              .toList()
              .join(' ')
              .replaceAll(RegExp(' +'), ' ');
        } else {
          value = '';
        }
        if (key.isNotEmpty) {
          if (isList) {
            if (valueList[itemNumber].isNotEmpty &&
                valueList[itemNumber].containsKey(key)) {
              itemNumber += 1;
            }

            if (valueList.asMap()[itemNumber] == null) {
              valueList.add({});
            }
            valueList[itemNumber][key] = value;
          } else {
            valueMap[key] = value;
          }
        }
      }
    }
    if (isList) {
      return valueList;
    }
    return valueMap;
  }

  ///formulate cpu information
  Map<String, dynamic> formatCpu(Map<String, dynamic> data) {
    final desc = data['Description'].toString().toLowerCase().split(' ');
    if (desc.contains('family')) {
      data['Family'] = desc[desc.indexOf('family') + 1];
    } else {
      data['Family'] = '';
    }
    if (desc.contains('model')) {
      data['Model'] = desc[desc.indexOf('model') + 1];
    } else {
      data['Model'] = '';
    }
    if (desc.contains('stepping')) {
      data['Stepping'] = desc[desc.indexOf('stepping') + 1];
    } else {
      data['Stepping'] = '';
    }
    return data;
  }

  ///formulate network adapter information
  static Map<String, dynamic> formatNetworkDetailsdata(
      List<Map<String, dynamic>> data) {
    Map<String, dynamic> finalData = {};
    for (var i = 0; i < data.length; i++) {
      if (data[i]['MACAddress'] == null ||
          (data[i]['MACAddress'] != null &&
              data[i]['MACAddress'] is String &&
              data[i]['MACAddress'].trim() == '')) {
        data.removeAt(i);
      } else {
        if (data[i]['NetConnectionID'].toString().trim().toLowerCase() ==
                'ethernet' ||
            data[i]['NetConnectionID'].toString().trim().toLowerCase() ==
                "wi-fi") {
          data[i]['type'] = 'wired';
        } else if (data[i]['NetConnectionID'] != null) {
          data[i]['NetConnectionID'] = data[i]['NetConnectionID'].trim();
        }
        finalData[(finalData.length + 1).toString()] = data[i];
        finalData[(finalData.length).toString()]['MACAddress'] =
            finalData[(finalData.length).toString()]['MACAddress']
                .toString()
                .toLowerCase()
                .trim()
                .replaceAll(' ', ':');
      }
    }
    return finalData;
  }

  ///formulate disk layout information(ssd, hdd:secondary storage)
  static Map<String, dynamic> formatDiskLayout(
      List<Map<String, dynamic>> diskDrive,
      List<Map<String, dynamic>> physicalDisk) {
    List<Map<String, dynamic>> mergedObject = [];
    Map<String, dynamic> disklayout = {};
    for (var i = 0; i < diskDrive.length; i++) {
      mergedObject.add({
        ...diskDrive[i],
        ...physicalDisk[physicalDisk.indexWhere((element) =>
            element['SerialNumber'].toString().toLowerCase().trim() ==
            diskDrive[i]['SerialNumber'].toString().toLowerCase().trim())],
      });
      disklayout[i.toString()] = mergedObject[i];
      disklayout[i.toString()]['Status'] =
          diskDrive[i]['Status'].toString().trim().toLowerCase() == 'ok'
              ? 'Ok'
              : diskDrive[i]['Status'].toString().trim().toLowerCase() ==
                      'degraded'
                  ? 'Degraded'
                  : diskDrive[i]['Status'].toString().trim().toLowerCase() ==
                          'pred fail'
                      ? 'Predicted Failure'
                      : 'Unknown';
    }
    return disklayout;
  }

  ///formulate memory data(RAM)
  static Map<String, dynamic> formatMemoryLayout(
      List<Map<String, dynamic>> data) {
    Map<String, dynamic> output = {};
    final memoryTypes =
        'Unknown|Other|DRAM|Synchronous DRAM|Cache DRAM|EDO|EDRAM|VRAM|SRAM|RAM|ROM|FLASH|EEPROM|FEPROM|EPROM|CDRAM|3DRAM|SDRAM|SGRAM|RDRAM|DDR|DDR2|DDR2 FB-DIMM|Reserved|DDR3|FBD2|DDR4|LPDDR|LPDDR2|LPDDR3|LPDDR4'
            .split('|');
    final formFactors =
        'Unknown|Other|SIP|DIP|ZIP|SOJ|Proprietary|SIMM|DIMM|TSOP|PGA|RIMM|SODIMM|SRIMM|SMD|SSMP|QFP|TQFP|SOIC|LCC|PLCC|BGA|FPBGA|LGA'
            .split('|');

    for (var i = 0; i < data.length; i++) {
      output['$i'] = data[i];
      try {
        output['$i']['MemoryType'] = output['$i']['MemoryType'] != null &&
                output['$i']['MemoryType'].toString().trim().isNotEmpty
            ? memoryTypes[int.parse(output['$i']['MemoryType'])]
            : memoryTypes[0];
        try {
          output['$i']['FormFactor'] =
              formFactors[int.parse(output['$i']['FormFactor'])];
        } catch (_) {}
        try {
          output['$i']
              ['SMBIOSMemoryType'] = output['$i']['SMBIOSMemoryType'] != null &&
                  output['$i']['SMBIOSMemoryType'].toString().trim().isNotEmpty
              ? memoryTypes[int.parse(output['$i']['SMBIOSMemoryType'])]
              : memoryTypes[0];
        } catch (_) {}
      } catch (_) {}
    }
    return output;
  }

  ///formulate chassis data
  static Map<String, dynamic> formatChassis(Map<String, dynamic> data) {
    final chassisTypes =
        "Other|Unknown|Desktop|Low Profile Desktop|Pizza Box|Mini Tower|Tower|Portable|Laptop|Notebook|Hand Held|Docking Station|All in One|Sub Notebook|Space-Saving|Lunch Box|Main System Chassis|Expansion Chassis|SubChassis|Bus Expansion Chassis|Peripheral Chassis|Storage Chassis|Rack Mount Chassis|Sealed-Case PC|Multi-System Chassis|Compact PCI|Advanced TCA|Blade|Blade Enclosure|Tablet|Convertible|Detachable|IoT Gateway |Embedded PC|Mini PC|Stick PC"
            .split('|');
    int ctype = int.tryParse(data['ChassisTypes']
            .toString()
            .replaceAll(RegExp(r"\p{P}", unicode: true), "")
            .trim()) ??
        1;

    data['ChassisTypes'] =
        ctype < chassisTypes.length ? chassisTypes[ctype - 1] : '';

    return data;
  }

  ///formulate graphics data
  static Map<String, dynamic> formatGraphics({
    required List<Map<String, dynamic>> videoControllerData,
    required List<Map<String, dynamic>> dSectionData,
    required List<Map<String, dynamic>> basicDisplayParamsData,
    required List<Map<String, dynamic>> monitorConnectionparameters,
    required List<Map<String, dynamic>> formsDataAllScreens,
  }) {
    List displayCombinedObject = [];

    const videoTypes = {
      '-2': 'UNINITIALIZED',
      '-1': 'OTHER',
      '0': 'HD15',
      '1': 'SVIDEO',
      '2': 'Composite video',
      '3': 'Component video',
      '4': 'DVI',
      '5': 'HDMI',
      '6': 'LVDS',
      '8': 'D_JPN',
      '9': 'SDI',
      '10': 'DP',
      '11': 'DP embedded',
      '12': 'UDI',
      '13': 'UDI embedded',
      '14': 'SDTVDONGLE',
      '15': 'MIRACAST',
      '2147483648': 'INTERNAL'
    };
    Map<String, dynamic> formatedData = {};

    formatedData['controllers'] = {};
    for (var i = 0; i < videoControllerData.length; i++) {
      formatedData['controllers']['$i'] = {};
      formatedData['controllers']['$i']['model'] =
          videoControllerData[i]['Name'];
      formatedData['controllers']['$i']['bus'] =
          videoControllerData[i]['PNPDeviceID'].toString().startsWith('PCI')
              ? 'PCI'
              : '';
      formatedData['controllers']['$i']['vendor'] =
          videoControllerData[i]['AdapterCompatibility'];
      formatedData['controllers']['$i']['vram'] =
          (int.parse(videoControllerData[i]['AdapterRAM'].toString()) / 1024) /
              1024;
      formatedData['controllers']['$i']['vramDynamic'] =
          videoControllerData[i]['VideoMemoryType'].toString().trim() == '2'
              ? true
              : false;
    }
    for (var i = 0; i < formsDataAllScreens.length; i++) {
      if (i < dSectionData.length &&
          dSectionData.indexWhere((element) => basicDisplayParamsData[i]
                      ['InstanceName']
                  .toString()
                  .toLowerCase()
                  .contains(dSectionData[i]['PNPDeviceID']
                      .toString()
                      .trim()
                      .toLowerCase())) >=
              0) {
        displayCombinedObject.add({
          ...basicDisplayParamsData[i],
          ...monitorConnectionparameters[monitorConnectionparameters.indexWhere(
              (itmInner) =>
                  itmInner['InstanceName'].toString().toLowerCase() ==
                  basicDisplayParamsData[i]['InstanceName']
                      .toString()
                      .toLowerCase())],
          ...formsDataAllScreens[i],
          ...dSectionData[dSectionData.indexWhere((element) =>
              basicDisplayParamsData[i]['InstanceName']
                  .toString()
                  .toLowerCase()
                  .contains(dSectionData[i]['PNPDeviceID']
                      .toString()
                      .trim()
                      .toLowerCase()))],
        });
      } else {
        displayCombinedObject.add({
          ...basicDisplayParamsData[i],
          ...monitorConnectionparameters[monitorConnectionparameters.indexWhere(
              (itmInner) =>
                  itmInner['InstanceName'].toString().toLowerCase() ==
                  basicDisplayParamsData[i]['InstanceName']
                      .toString()
                      .toLowerCase())],
          ...formsDataAllScreens[i],
        });
      }
    }

    ///display
    formatedData['displays'] = {};
    for (var displayIndex = 0;
        displayIndex < displayCombinedObject.length;
        displayIndex++) {
      String bounds = displayCombinedObject[displayIndex]['Bounds']
          .toString()
          .replaceAll(RegExp("{|}"), '');

      Map<String, dynamic> boundsMap = GeneralHelper.getValueAsMap(
          data: bounds.toString().replaceAll(',', '\n'), seprator: '=');

      formatedData['displays']['$displayIndex'] = {};

      formatedData['displays']['$displayIndex']['bulletin'] =
          displayCombinedObject[displayIndex]['VideoOutputTechnology']
                      .toString()
                      .trim() ==
                  '2147483648'
              ? true
              : false;
      formatedData['displays']['$displayIndex']['connection'] = videoTypes[
          displayCombinedObject[displayIndex]['VideoOutputTechnology']
              .toString()
              .trim()];
      formatedData['displays']['$displayIndex']['pixelDepth'] =
          displayCombinedObject[displayIndex]['BitsPerPixel'];

      formatedData['displays']['$displayIndex']['vendor'] =
          displayCombinedObject[displayIndex]['MonitorManufacturer'];

      formatedData['displays']['$displayIndex']['model'] =
          displayCombinedObject[displayIndex]['Name'];

      formatedData['displays']['$displayIndex']['main'] =
          displayCombinedObject[displayIndex]['Primary'];

      formatedData['displays']['$displayIndex']['resolutionX'] =
          boundsMap['Width'];

      formatedData['displays']['$displayIndex']['resolutionY'] =
          boundsMap['Height'];

      formatedData['displays']['$displayIndex']['sizeX'] =
          displayCombinedObject[displayIndex]['MaxHorizontalImageSize'];

      formatedData['displays']['$displayIndex']['sizeY'] =
          displayCombinedObject[displayIndex]['MaxVerticalImageSize'];

      formatedData['displays']['$displayIndex']['currentResX'] =
          boundsMap['Width'];

      formatedData['displays']['$displayIndex']['currentResY'] =
          boundsMap['Height'];

      formatedData['displays']['$displayIndex']['positionX'] = boundsMap['X'];

      formatedData['displays']['$displayIndex']['positionY'] = boundsMap['Y'];
    }
    return formatedData;
  }

  ///formulate system infomations
  static Map<String, dynamic> formatSystemInfo(Map<String, dynamic> data) {
    final model = data['Name'].toString().toLowerCase();
    final manufacturer = data['Vendor'].toString().toLowerCase();
    if (model == 'virtualbox' ||
        model == 'kvm' ||
        model == 'virtual machine' ||
        model == 'bochs' ||
        model.startsWith('vmware') ||
        model.startsWith('qemu')) {
      data['virtual'] = true;
      if (model.startsWith('virtualbox')) {
        data['virtualHost'] = 'VirtualBox';
      }
      if (model.startsWith('vmware')) {
        data['virtualHost'] = 'VMware';
      }
      if (model.startsWith('kvm')) {
        data['virtualHost'] = 'KVM';
      }
      if (model.startsWith('bochs')) {
        data['virtualHost'] = 'bochs';
      }
      if (model.startsWith('qemu')) {
        data['virtualHost'] = 'KVM';
      }
    }
    if (manufacturer.startsWith('vmware') ||
        manufacturer.startsWith('qemu') ||
        manufacturer == 'xen') {
      data['virtual'] = true;
      if (manufacturer.startsWith('vmware')) {
        data['virtualHost'] = 'VMware';
      }
      if (manufacturer.startsWith('xen')) {
        data['virtualHost'] = 'Xen';
      }
      if (manufacturer.startsWith('qemu')) {
        data['virtualHost'] = 'KVM';
      }
    }
    if (!(data['virtual'] == true)) {
      String lines = powerShell(
          'Get-WmiObject Win32_bios | select Version, SerialNumber, SMBIOSBIOSVersion');
      //WMIC /namespace:\\root\cimv2 path Win32_bios GET Version,SerialNumber,SMBIOSBIOSVersion /format:list
      if (lines.contains('VRTUAL') ||
          lines.contains('A M I ') ||
          lines.contains('VirtualBox') ||
          lines.contains('VMWare') ||
          lines.contains('Xen')) {
        data['virtual'] = true;
        if (lines.contains('VirtualBox') && data['virtualHost'] == null) {
          data['virtualHost'] = 'VirtualBox';
        }
        if (lines.contains('VMware') && data['virtualHost'] == null) {
          data['virtualHost'] = 'VMware';
        }
        if (lines.contains('Xen') && data['virtualHost'] == null) {
          data['virtualHost'] = 'Xen';
        }
        if (lines.contains('VRTUAL') && data['virtualHost'] == null) {
          data['virtualHost'] = 'Hyper-V';
        }
        if (lines.contains('A M I') && data['virtualHost'] == null) {
          data['virtualHost'] = 'Virtual PC';
        }
      }
    }

    return data;
  }

  ///will run in cmd if powershell doesn't support,
  ///
  /// some value will be compromised
  static String powerShell(String cmd) {
    var process = Process.runSync('Powershell.exe', [cmd]);
    String result = process.stdout as String;
    if (process.exitCode != 0) {
      if (_aCmd.containsKey(cmd)) {
        process = Process.runSync(_aCmd[cmd] ?? '', [], runInShell: true);
        result = process.stdout as String;
        result = result.replaceAll('=', ':');
        if (process.exitCode != 0) {
          // return process.stderr as String;
          return '';
        }
      }
      return '';
    }
    return result;
  }

  ///will help to wait until a varible become false
  ///
  ///work perfect on static, otherwise order violates
  static Future waitWhile(bool Function() test,
      [Duration pollInterval = Duration.zero]) {
    var completer = Completer();
    check() {
      if (!test()) {
        completer.complete();
      } else {
        Timer(pollInterval, check);
      }
    }

    check();
    return completer.future;
  }
}

import 'package:windows_system_info/models/windows_system_info.dart';

class MemoryInfo extends WindowsSystemInformation {
  @override
  List<Object?> get props => [
        bank,
        clockSpeed,
        formFactor,
        manufacturer,
        partNum,
        serialNum,
        size,
        type,
        voltageConfigured,
        voltageMax,
        voltageMin,
      ];

  /// bank: "BANK 0"
  /// clockSpeed: 0
  /// formFactor: "SODIMM"
  /// manufacturer: "80AD"
  /// partNum: "XXXXXXXXXX-PB"
  /// serialNum: "0F421A69"
  /// size: 4294967296
  /// type: "DDR3"
  /// voltageConfigured: 0
  /// voltageMax: 0
  /// voltageMin: 0

  final String bank;
  final int clockSpeed;
  final String formFactor;
  final String manufacturer;
  final String partNum;
  final String serialNum;
  final int size;
  final String type;
  final int voltageConfigured;
  final int voltageMax;
  final int voltageMin;

  MemoryInfo({
    required this.bank,
    required this.clockSpeed,
    required this.formFactor,
    required this.manufacturer,
    required this.partNum,
    required this.serialNum,
    required this.size,
    required this.type,
    required this.voltageConfigured,
    required this.voltageMax,
    required this.voltageMin,
  });
  static List<MemoryInfo> fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> memory = json['memlayout'] ?? {};
    List<MemoryInfo> memoryList = [];
    for (var i = 0; i < memory.length; i++) {
      MemoryInfo memInfo = MemoryInfo(
        bank: memory['$i']['BankLabel'],
        clockSpeed:
            int.tryParse(memory['$i']['ConfiguredClockSpeed'].toString()) ?? 0,
        formFactor: memory['$i']['FormFactor'],
        manufacturer: memory['$i']['Manufacturer'],
        partNum: memory['$i']['PartNumber'],
        serialNum: memory['$i']['SerialNumber'],
        size: int.tryParse(memory['$i']['Capacity'].toString()) ?? 0,
        type: memory['$i']['MemoryType'].toString().toLowerCase() != 'null' &&
                memory['$i']['MemoryType']
                    .toString()
                    .toLowerCase()
                    .trim()
                    .isNotEmpty
            ? memory['$i']['MemoryType'].toString()
            : memory['$i']['SMBIOSMemoryType'].toString().toLowerCase() !=
                        'null' &&
                    memory['$i']['SMBIOSMemoryType']
                        .toString()
                        .toLowerCase()
                        .trim()
                        .isNotEmpty
                ? memory['$i']['SMBIOSMemoryType'].toString().toLowerCase()
                : '',
        voltageConfigured:
            int.tryParse(memory['$i']['ConfiguredVoltage'].toString()) ?? 0,
        voltageMax: int.tryParse(memory['$i']['MaxVoltage'].toString()) ?? 0,
        voltageMin: int.tryParse(memory['$i']['MinVoltage'].toString()) ?? 0,
      );
      memoryList.add(memInfo);
    }
    return memoryList;
  }
}

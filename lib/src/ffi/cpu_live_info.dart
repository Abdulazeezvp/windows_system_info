import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;

typedef _GetDoubleNative = Double Function();
typedef _GetDoubleDart = double Function();
typedef _UpdateSensorsNative = Void Function();
typedef _UpdateSensorsDart = void Function();

class LiveSystemInfo {
  final double cpuTemperature;
  final double cpuLoad;
  final double gpuTemperature;
  final double gpuLoad;
  final double memoryUsed;
  final double memoryTotal;
  final double memoryLoad;

  LiveSystemInfo({
    required this.cpuTemperature,
    required this.cpuLoad,
    required this.gpuTemperature,
    required this.gpuLoad,
    required this.memoryUsed,
    required this.memoryTotal,
    required this.memoryLoad,
  });

  bool get hasCpuTemp => cpuTemperature >= 0;
  bool get hasCpuLoad => cpuLoad >= 0;
  bool get hasGpuTemp => gpuTemperature >= 0;
  bool get hasGpuLoad => gpuLoad >= 0;
  bool get hasMemoryInfo => memoryUsed >= 0;

  double get memoryUsedPercent =>
      memoryTotal > 0 ? (memoryUsed / memoryTotal) * 100 : -1;

  @override
  String toString() {
    final buffer = StringBuffer('System Information:\n');
    
    if (hasCpuTemp) {
      buffer.writeln('  CPU Temp: ${cpuTemperature.toStringAsFixed(1)}°C');
    } else {
      buffer.writeln('  CPU Temp: N/A');
    }

    if (hasCpuLoad) {
      buffer.writeln('  CPU Load: ${cpuLoad.toStringAsFixed(1)}%');
    } else {
      buffer.writeln('  CPU Load: N/A');
    }

    if (hasGpuTemp) {
      buffer.writeln('  GPU Temp: ${gpuTemperature.toStringAsFixed(1)}°C');
    } else {
      buffer.writeln('  GPU Temp: N/A');
    }

    if (hasGpuLoad) {
      buffer.writeln('  GPU Load: ${gpuLoad.toStringAsFixed(1)}%');
    } else {
      buffer.writeln('  GPU Load: N/A');
    }

    if (hasMemoryInfo) {
      buffer.writeln('  Memory: ${memoryUsed.toStringAsFixed(2)}/${memoryTotal.toStringAsFixed(2)} GB (${memoryLoad.toStringAsFixed(1)}%)');
    } else {
      buffer.writeln('  Memory: N/A');
    }

    return buffer.toString();
  }

  Map<String, dynamic> toJson() => {
    'cpuTemperature': cpuTemperature,
    'cpuLoad': cpuLoad,
    'gpuTemperature': gpuTemperature,
    'gpuLoad': gpuLoad,
    'memoryUsed': memoryUsed,
    'memoryTotal': memoryTotal,
    'memoryLoad': memoryLoad,
  };
}

class CpuLiveInfo {
  late final DynamicLibrary _lib;
  late final _GetDoubleDart _getCpuTemp;
  late final _GetDoubleDart _getCpuLoad;
  late final _GetDoubleDart _getGpuTemp;
  late final _GetDoubleDart _getGpuLoad;
  late final _GetDoubleDart _getMemoryUsed;
  late final _GetDoubleDart _getMemoryTotal;
  late final _GetDoubleDart _getMemoryLoad;
  late final _UpdateSensorsDart _updateSensors;

  CpuLiveInfo() {
    final exeDir = File(Platform.resolvedExecutable).parent.path;

    final dllPath = '$exeDir\\CpuTempWrapper.dll';
    if (!File(dllPath).existsSync()) {
      _copyDlls(exeDir);
    }
    
    _lib = DynamicLibrary.open(dllPath);
    
    // Load all function pointers
    _getCpuTemp = _lib
        .lookup<NativeFunction<_GetDoubleNative>>('getCpuTemperature')
        .asFunction();
    
    _getCpuLoad = _lib
        .lookup<NativeFunction<_GetDoubleNative>>('getCpuLoad')
        .asFunction();
    
    _getGpuTemp = _lib
        .lookup<NativeFunction<_GetDoubleNative>>('getGpuTemperature')
        .asFunction();
    
    _getGpuLoad = _lib
        .lookup<NativeFunction<_GetDoubleNative>>('getGpuLoad')
        .asFunction();
    
    _getMemoryUsed = _lib
        .lookup<NativeFunction<_GetDoubleNative>>('getMemoryUsed')
        .asFunction();
    
    _getMemoryTotal = _lib
        .lookup<NativeFunction<_GetDoubleNative>>('getMemoryTotal')
        .asFunction();
    
    _getMemoryLoad = _lib
        .lookup<NativeFunction<_GetDoubleNative>>('getMemoryLoad')
        .asFunction();
    
    _updateSensors = _lib
        .lookup<NativeFunction<_UpdateSensorsNative>>('updateSensors')
        .asFunction();
  }

  void _copyDlls(String destDir) {
    final pluginPath = _findPluginDirectory();
    
    if (pluginPath == null) {
      throw Exception('Could not locate windows_system_info plugin directory');
    }
    
    print('Found plugin at: $pluginPath');
    final publishDir = path.join(
      pluginPath,
      'windows',
      'CpuTempWrapper',
      'bin',
      'Release',
      'net8.0-windows',
      'win-x64',
      'publish'
    );
    
    final dir = Directory(publishDir);
    if (dir.existsSync()) {
      for (final file in dir.listSync()) {
        if (file is File && file.path.endsWith('.dll')) {
          final fileName = path.basename(file.path);
          final dest = path.join(destDir, fileName);
          try {
            file.copySync(dest);
            print('✓ Copied $fileName');
          } catch (e) {
            print('✗ Failed to copy $fileName: $e');
          }
        }
      }
    } else {
      print('✗ Publish directory not found: $publishDir');
    }
    
    final libreDll = File(path.join(
      pluginPath, 
      'windows', 
      'CpuTempWrapper', 
      'LibreHardwareMonitorLib.dll'
    ));
    
    if (libreDll.existsSync()) {
      try {
        libreDll.copySync(path.join(destDir, 'LibreHardwareMonitorLib.dll'));
        print('Copied LibreHardwareMonitorLib.dll');
      } catch (e) {
        print('Failed to copy LibreHardwareMonitorLib.dll: $e');
      }
    } else {
      print('LibreHardwareMonitorLib.dll not found at: ${libreDll.path}');
    }
  }

  String? _findPluginDirectory() {
    final scriptUri = Platform.script;
    if (scriptUri.scheme == 'file') {
      var currentPath = path.dirname(scriptUri.toFilePath());
      for (int i = 0; i < 10; i++) {
        final windowsDir = Directory(path.join(currentPath, 'windows', 'CpuTempWrapper'));
        if (windowsDir.existsSync()) {
          return currentPath;
        }
        
        final pubspecFile = File(path.join(currentPath, 'pubspec.yaml'));
        if (pubspecFile.existsSync()) {
          final content = pubspecFile.readAsStringSync();
          if (content.contains('name: windows_system_info')) {
            return currentPath;
          }
        }
        
        final parentPath = path.dirname(currentPath);
        if (parentPath == currentPath) break; 
        currentPath = parentPath;
      }
    }
    
    final exeDir = path.dirname(Platform.resolvedExecutable);
    final possibilities = [
      path.normalize(path.join(exeDir, '..', '..', '..', '..', '..')),
      path.normalize(path.join(exeDir, '..', '..', '..', '..')),
    ];
    
    for (final dir in possibilities) {
      final windowsDir = Directory(path.join(dir, 'windows', 'CpuTempWrapper'));
      final pubspecFile = File(path.join(dir, 'pubspec.yaml'));
      
      if (windowsDir.existsSync() && pubspecFile.existsSync()) {
        final content = pubspecFile.readAsStringSync();
        if (content.contains('name: windows_system_info')) {
          return dir;
        }
      }
    }
    
    var currentDir = Directory.current.path;
    for (int i = 0; i < 10; i++) {
      final windowsDir = Directory(path.join(currentDir, 'windows', 'CpuTempWrapper'));
      final pubspecFile = File(path.join(currentDir, 'pubspec.yaml'));
      
      if (windowsDir.existsSync() && pubspecFile.existsSync()) {
        final content = pubspecFile.readAsStringSync();
        if (content.contains('name: windows_system_info')) {
          return currentDir;
        }
      }
      
      final parentDir = path.dirname(currentDir);
      if (parentDir == currentDir) break;
      currentDir = parentDir;
    }
    
    return null;
  }

  /// Get CPU temperature in Celsius (-1 if unavailable)
  double getCpuTemperature() => _getCpuTemp();

  /// Get CPU load percentage 0-100 (-1 if unavailable)
  double getCpuLoad() => _getCpuLoad();

  /// Get GPU temperature in Celsius (-1 if unavailable)
  double getGpuTemperature() => _getGpuTemp();

  /// Get GPU load percentage 0-100 (-1 if unavailable)
  double getGpuLoad() => _getGpuLoad();

  /// Get memory used in GB (-1 if unavailable)
  double getMemoryUsed() => _getMemoryUsed();

  /// Get total memory in GB (-1 if unavailable)
  double getMemoryTotal() => _getMemoryTotal();

  /// Get memory load percentage 0-100 (-1 if unavailable)
  double getMemoryLoad() => _getMemoryLoad();

  /// Update all sensors at once (more efficient when reading multiple values)
  void updateSensors() => _updateSensors();

  /// Get all system information at once
  /// This is the most efficient way to read multiple values
  LiveSystemInfo getAllInfo() {
    updateSensors(); // Update all sensors once
    return LiveSystemInfo(
      cpuTemperature: _getCpuTemp(),
      cpuLoad: _getCpuLoad(),
      gpuTemperature: _getGpuTemp(),
      gpuLoad: _getGpuLoad(),
      memoryUsed: _getMemoryUsed(),
      memoryTotal: _getMemoryTotal(),
      memoryLoad: _getMemoryLoad(),
    );
  }
}
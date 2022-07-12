<h2>windows_system_info</h2>
A Dart package to get detailed information of windows machine.

## Features

Supported platform:
Windows
(it will be better if there is powershell)

| Getter        | Type       | Desc  |
| ------------- |:-------------:| ----- |
| userName      | String | user's profile name |
| windowsSystemInformation      | AllInfo? | complete information about details |
| windowsSystemStaticInformation | DeviceStaticinfo?      | all static information  of device |
| deviceName | String | device name |
| is64bit | bool      | true if 64 bit os is installed|
| is32bit | bool      |   true if 32 bit os isntalled |
| isInitInProgress | bool      | true if initializing is in progress|
| isInitilized | Future bool     | true once initilisation completed |
| disks | List(DiskLayoutInfo)      |    info like hdds,ssd attached to device |
| graphics | GraphicsInfo  |   will return graphics related information of device |
| memories | List(MemoryInfo)     |   will get a list of memory(ram) attached to device |
| network |  List(NetworkInfo) | will get detail of network adapter ie:focused on mac address |
| baseBoard | BaseBoardInfo?  | return information of base board of device |
| chassis | ChassisInfo?      |    return infomation of chassis of device,like laptop, manufacturer etc... |
| system | SystemInfo? |  will return basic system information, like manufacturer etc... |
| os | OsInfo? | will return operating system information, like version of windows, build etc... |
| bios | BiosInfo? |  return bios information |


## Getting started

1. include latest windows_system_info package

2. import it

```dart
import 'package:windows_system_info/windows_system_info.dart';
```

3. initialize
```dart
await WindowsSystemInfo.initWindowsInfo();
```

4. get values using getter
```dart
WindowsSystemInfo.cpu
```

## Usage


```dart
  @override
  void initState() {
    super.initState();
    initInfo();
  }

  Future<void> initInfo() async {
    await WindowsSystemInfo.initWindowsInfo();
    if (await WindowsSystemInfo.isInitilized) {
      print(WindowsSystemInfo.cpu);
    }
  }
```

## Additional information

<h3>Before contributing...</h3>
Always welcome PR, but make sure warning is mininmum and follow darts guide lines for coding and documention. Always try to add comment about expected output, logic etc...
<br>
<br>
Inspired from <a href="https://www.npmjs.com/package/systeminformation">js systeminformation package</a>

import 'package:flutter/material.dart';
import 'package:windows_system_info/windows_system_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Windows details app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExampleWinodwSDetailsApp(),
    );
  }
}

class ExampleWinodwSDetailsApp extends StatefulWidget {
  const ExampleWinodwSDetailsApp({Key? key}) : super(key: key);

  @override
  State<ExampleWinodwSDetailsApp> createState() =>
      _ExampleWinodwSDetailsAppState();
}

class _ExampleWinodwSDetailsAppState extends State<ExampleWinodwSDetailsApp> {
  static CpuInfo? _cpuInfo;

  @override
  void initState() {
    super.initState();
    initInfo();
  }

  Future<void> initInfo() async {
    await WindowsSystemInfo.initWindowsInfo();
    if (await WindowsSystemInfo.isInitilized) {
      setState(() {
        _cpuInfo = WindowsSystemInfo.cpu;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: _cpuInfo != null
            ? [
                const Text('CPU INFO'),
                const Divider(
                  height: 8.0,
                ),
                Text('CPU Manufacturer : ${_cpuInfo?.manufacturer}'),
                Text('CPU Model : ${_cpuInfo?.model}'),
                Text('CPU Cores : ${_cpuInfo?.cores}'),
              ]
            : const [Center(child: CircularProgressIndicator())],
      ),
    );
  }
}

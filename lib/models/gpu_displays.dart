import 'package:windows_system_info/models/windows_system_info.dart';

class Display extends WindowsSystemInformation {
  @override
  List<Object?> get props => [
        builtin,
        connection,
        currentResX,
        currentResY,
        main,
        model,
        pixeldepth,
        positionX,
        positionY,
        resolutionx,
        resolutiony,
        sizex,
        sizey,
        vendor,
      ];

  ///Example:
  ///  builtin: true
  /// connection: "INTERNAL"
  /// currentResX: 1440
  /// currentResY: 900
  /// main: false
  /// model: "Generic PnP Monitor"
  /// pixeldepth: "32"
  /// positionX: 1920
  /// positionY: 290
  /// resolutionx: 1440
  /// resolutiony: 900
  /// sizex: 30
  /// sizey: 19
  /// vendor: "(Standard monitor types)"

  final bool builtin;
  final String connection;
  final int currentResX;
  final int currentResY;
  final bool main;
  final String model;
  final String pixeldepth;
  final int positionX;
  final int positionY;
  final int resolutionx;
  final int resolutiony;
  final int sizex;
  final int sizey;
  final String vendor;

  Display({
    required this.builtin,
    required this.connection,
    required this.currentResX,
    required this.currentResY,
    required this.main,
    required this.model,
    required this.pixeldepth,
    required this.positionX,
    required this.positionY,
    required this.resolutionx,
    required this.resolutiony,
    required this.sizex,
    required this.sizey,
    required this.vendor,
  });

  ///pass only display data as map
  static List<Display> fromJson(Map<String, dynamic> json) {
    List<Display> displayList = [];
    for (var i = 0; i < json.length; i++) {
      Display display = Display(
        builtin: json['$i']['bulletin'],
        connection: json['$i']['connection'],
        currentResX: int.tryParse(json['$i']['currentResX'].toString()) ?? 0,
        currentResY: int.tryParse(json['$i']['currentResY'].toString()) ?? 0,
        main: json['$i']['main'].toString().toLowerCase() == 'true'
            ? true
            : false,
        model: json['$i']['model'].toString(),
        pixeldepth: json['$i']['pixeldepth'].toString(),
        positionX: int.tryParse(json['$i']['positionX'].toString()) ?? 0,
        positionY: int.tryParse(json['$i']['positionY'].toString()) ?? 0,
        resolutionx: int.tryParse(json['$i']['resolutionx'].toString()) ?? 0,
        resolutiony: int.tryParse(json['$i']['resolutiony'].toString()) ?? 0,
        sizex: int.tryParse(json['$i']['sizex'].toString()) ?? 0,
        sizey: int.tryParse(json['$i']['sizey'].toString()) ?? 0,
        vendor: json['$i']['vendor'].toString(),
      );
      displayList.add(display);
    }
    return displayList;
  }
}

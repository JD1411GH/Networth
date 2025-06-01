import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:networth/widgets/toaster.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static final Utils _instance = Utils._internal();

  factory Utils() {
    return _instance;
  }

  Utils._internal() {
    // init
  }

  T convertRawToDatatype<T>(
    Map raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    Map<String, dynamic> map = Map<String, dynamic>.from(raw);
    return fromJson(map);
  }

  Map<String, dynamic> convertRawToJson(dynamic raw) {
    if (raw is Map) {
      Map<String, dynamic> map = Map<String, dynamic>.from(raw);
      return map;
    } else {
      throw Exception("Raw data is not a Map");
    }
  }

  final List<Color> darkColors = [
    Colors.lightGreen,
    Colors.redAccent,
    Colors.blueAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.deepPurpleAccent,
    Colors.lightBlueAccent,
    Colors.indigoAccent,
    Colors.brown,
    Colors.blueGrey,
    Colors.black,
    Colors.grey,
    Colors.deepOrange,
    Colors.teal,
    Colors.cyan,
    Colors.orange,
  ];
  Color getRandomDarkColor() {
    final random = Random();
    return darkColors[random.nextInt(darkColors.length)];
  }

  final List<Color> lightColors = [
    Colors.greenAccent,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.amberAccent,
    Colors.tealAccent,
    const Color.fromARGB(255, 153, 249, 249),
    Colors.limeAccent,
    Color.fromARGB(255, 255, 169, 169),
    const Color.fromARGB(255, 248, 139, 175),
    Color.fromARGB(255, 235, 124, 255),
  ];
  Color getRandomLightColor() {
    return lightColors[DateTime.now().millisecond % lightColors.length];
  }

  String formatIndianCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    final number = int.parse(
      amount.toString().replaceAll(RegExp(r'[^\d]'), ''),
    );
    return formatter.format(number);
  }

  void printType(dynamic value) {
    print("${value.runtimeType}: $value");
  }

  Future<void> sendWhatsAppMessage(String phoneNumber, String message) async {
    final url = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Toaster().error('Could not launch WhatsApp');
    }
  }
}

import 'package:elders_ai_app/configs/application.dart';
import 'package:elders_ai_app/configs/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const Injector(child: MainApp()));
}

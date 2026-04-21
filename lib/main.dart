import 'package:base_project/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:base_project/app/app.dart';
import 'package:base_project/app/di.dart';
import 'package:base_project/common/network/dio_helper.dart';
import 'package:base_project/common/resources/language_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Future.wait([
    EasyLocalization.ensureInitialized(),
    DioHelper.init(),
    initAppModule(),
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: const [ENGLISH_LOCALE, ARABIC_LOCALE],
      path: ASSET_PASS_LANGUAGE,
      child: MyApp(),
    ),
  );
}
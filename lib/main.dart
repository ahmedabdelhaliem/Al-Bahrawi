import 'package:al_bahrawi/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:al_bahrawi/app/app.dart';
import 'package:al_bahrawi/app/di.dart';
import 'package:al_bahrawi/common/network/dio_helper.dart';
import 'package:al_bahrawi/common/resources/language_manager.dart';

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

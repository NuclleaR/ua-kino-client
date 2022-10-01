import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uakino/constants.dart';
import 'package:uakino/grid_page.dart';
import 'package:uakino/home_page.dart';
import 'package:uakino/logger/logger.dart';
import 'package:uakino/media_page.dart';
import 'package:uakino/scaffold_getx.dart';
import 'package:uakino/search_page.dart';
import 'package:uakino/theme.dart';
import 'package:uakino/translations/messages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    logger.i("[DEVICE LOCALE]: ${Get.deviceLocale}");

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: GetMaterialApp(
        theme: theme,
        translations: Messages(),
        locale: const Locale('ua', 'UA'),
        fallbackLocale: const Locale('en', 'US'),
        // defaultTransition: Transition.fade,
        initialBinding: AppBinding(),
        initialRoute: homeRoute,
        getPages: [
          GetPage(
            name: homeRoute,
            page: () => const HomePage(),
          ),
          GetPage(
            name: gridRoute,
            page: () => const GridPage(),
            binding: MediaGridBinding(),
          ),
          GetPage(
            name: mediaItemRoute,
            page: () => const MediaPage(),
            binding: MediaResourceBinding(),
          ),
          GetPage(
            name: searchRoute,
            page: () => const SearchPage(),
            binding: SearchBinding(),
          ),
        ],
        // theme: ThemeData(
        //   // This is the theme of your application.
        //   //
        //   // Try running your application with "flutter run". You'll see the
        //   // application has a blue toolbar. Then, without quitting the app, try
        //   // changing the primarySwatch below to Colors.green and then invoke
        //   // "hot reload" (press "r" in the console where you ran "flutter run",
        //   // or simply save your changes to "hot reload" in a Flutter IDE).
        //   // Notice that the counter didn't reset back to zero; the application
        //   // is not restarted.
        //   primarySwatch: Colors.teal,
        // ),
      ),
    );
  }
}

// Placeholder()

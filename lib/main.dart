import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/setting_page.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/providers/weather_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context)=> WeatherProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> pokeballRedSwatch = {
      50: const Color.fromARGB(255, 0, 204, 255),
      100: const Color.fromARGB(255, 0, 204, 255),
      200: const Color.fromARGB(255, 0, 204, 255),
      300: const Color.fromARGB(255, 0, 204, 255),
      400: const Color.fromARGB(255, 0, 204, 255),
      500: const Color.fromARGB(255, 0, 204, 255),
      600: const Color.fromARGB(255, 0, 204, 255),
      700: const Color.fromARGB(255, 0, 204, 255),
      800: const Color.fromARGB(255, 0, 204, 255),
      900: const Color.fromARGB(255, 0, 204, 255),
    };
    MaterialColor appColor = MaterialColor(0xff00CCFF, pokeballRedSwatch);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "MerriweatherSans",

        primarySwatch: appColor,
      ),
      initialRoute: WeatherPage.routeName,
      routes: {
        WeatherPage.routeName : (context) => const WeatherPage(),
        SettingPage.routeName : (context) => const SettingPage(),
      },
    );
  }
}

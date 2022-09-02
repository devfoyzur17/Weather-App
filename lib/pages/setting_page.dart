
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class SettingPage extends StatefulWidget {
  static const routeName ="/setting-page";
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) =>
       ListView(
          padding: EdgeInsets.all(8),
          children: [

            SwitchListTile(
              title: Text("Show temperature in Fahrenheit"),
                subtitle: Text("Default is celsius"),
                value: provider.isFahrenheit,
                onChanged: (value) async{
                provider.setTempUnit(value);
                await provider.setPreferenceTempUnitValue(value);
                provider.getWeatherData();

            })
          ],
        ),
      ),

    );
  }
}

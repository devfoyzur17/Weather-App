import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/helper_function.dart';
import 'package:weather_app/utils/location_utils.dart';
import 'package:weather_app/utils/text_styles.dart';

class WeatherPage extends StatefulWidget {
  static const routeName = "/";
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late WeatherProvider provider;
  bool isFirst = true;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      provider = Provider.of<WeatherProvider>(context);
      _getData();

      isFirst = false;
    }

    super.didChangeDependencies();
  }

  _getData() {
    determinePosition().then((position) {
      provider.setNewLocation(position.latitude, position.longitude);
      provider.getWeatherData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var appbarHeight = AppBar().preferredSize.height;
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/images/night.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: statusBarHeight,
            child: Container(
              height: appbarHeight,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Weather",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.my_location_rounded,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ),
          provider.hasDataLoaded
              ? Positioned(
                  top: appbarHeight + statusBarHeight,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        (appbarHeight + statusBarHeight),
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        _currentWeatherSection(),
                        _forecastWeatherSection()
                      ],
                    ),
                  ),
                )
              : const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _currentWeatherSection() {
    final response = provider.currentResponseModel;
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
          color: Color(0xff001f4d).withOpacity(0.8),
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today",
                style: txtNormal16,
              ),
              Text(
                getFormattedDate(response!.dt!, "dd/MM/yyyy"),
                style: TextStyle(color: Colors.white, fontSize: 13),
              )
            ],
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                    "$iconPrefix${response.weather![0].icon}$iconSuffix",
                    color: Colors.amber),
                Text(
                  "${response.main!.temp!.round()} $degree$celsius",
                  style: TextStyle(color: Colors.white, fontSize: 55),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sunrise ${getFormattedTime(response.sys!.sunrise!, "hh:mm:ss")}",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              Text(
                "Sunset ${getFormattedTime(response.sys!.sunset!, "hh:mm:ss")}",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Wrap(
            children: [
              Text(
                "feels like ${response.main!.feelsLike!.round()}$degree$celsius  ",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                "   ${response.weather![0].main},  ${response.weather![0].description}",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              )
            ],
          ),
          Wrap(
            children: [
              Text(
                "Humidity ${response.main!.humidity}%",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                "   Pressure ${response.main!.pressure}hPa",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                "Visibility ${response.visibility}meter",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                "   Wind ${response.wind!.speed}m/s",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                "Degree ${response.wind!.deg}$degree",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.amber,
              ),
              Text(
                "${response.name!}, ${response.sys!.country}",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _forecastWeatherSection() {
    return Center();
  }
}
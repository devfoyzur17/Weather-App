import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/setting_page.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/helper_function.dart';
import 'package:weather_app/utils/location_utils.dart';

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

  _getData() async {
    final locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationEnabled) {
      EasyLoading.showToast('Location is disabled');
      await Geolocator.getCurrentPosition();
      _getData();
    }
    try {
      final position = await determinePosition();
      provider.setNewLocation(position.latitude, position.longitude);
      provider.setTempUnit(await provider.getPreferenceTempUnitValue());
      provider.getWeatherData();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var appbarHeight = AppBar().preferredSize.height;
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      backgroundColor: Color(0xff0C1824),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,

              children: [
                SvgPicture.asset(
                  "assets/images/1.svg",
                  height: (MediaQuery.of(context).size.height / 3) * 2.2,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),

                Container(
                  height: (MediaQuery.of(context).size.height / 3) * 0.8,
                )


              ],
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
                      style: TextStyle(
                          color: Color(0xff0C1824),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () async {
                          final result = await showSearch(
                              context: context, delegate: _citySearchDelegate());
                          if (result != null && result.isNotEmpty) {
                            provider.convertAddressToLatLong(result);
                          }
                        },
                        icon: Icon(
                          Icons.search,
                          color: Color(0xff0C1824),
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SettingPage.routeName);
                        },
                        icon: Icon(
                          Icons.settings,
                          color: Color(0xff0C1824),
                        )),
                  ],
                ),
              ),
            ),


            provider.hasDataLoaded
                ? Positioned(
                    top: appbarHeight + statusBarHeight,
                    child: SizedBox(
                      height: 1000,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [

                          Divider(color:  Color(0xff0C1824),),
                          _currentWeatherSection(),
                          _forecastWeatherSection(),
                        ],
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getData();
        },
        child: Icon(
          Icons.my_location_rounded,
          color: Color(0xff0C1824),
        ),
      ),
    );
  }

  Widget _currentWeatherSection() {
    final response = provider.currentResponseModel;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
            color: Color(0xff00141a).withOpacity(0.4),
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
                  style: TextStyle(color: Colors.white, fontSize: 16),

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
                     ),
                  Text(
                    "${response.main!.temp!.round()} $degree${provider.unitSymbol}",
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
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  "   ${response.weather![0].main},  ${response.weather![0].description}",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                )
              ],
            ),
            Wrap(
              children: [
                Text(
                  "Humidity ${response.main!.humidity}%",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  "   Pressure ${response.main!.pressure}hPa",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  "Visibility ${response.visibility}meter",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  "   Wind ${response.wind!.speed}m/s",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  "Degree ${response.wind!.deg}$degree",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.white70,
                ),
                Text(
                  "${response.name!}, ${response.sys!.country}",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _forecastWeatherSection() {
    final response = provider.forecastResponseModel;
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          "Forecast Weather",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 1,
              wordSpacing: 1),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: response!.list!.length,
            itemBuilder: (context, index) {
              final model = response.list![index];

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    
                    Text(getFormattedDate(model.dt!, "pattern",),style: TextStyle(color: Colors.white,fontSize: 13),),
                    Text(getFormattedTime(model.dt!, "pattern"),style: TextStyle(color: Colors.white,fontSize: 13),),
                    Image.network(
                        "$iconPrefix${model.weather![0].icon}$iconSuffix",
                        color: Colors.amber,height: 80,),
                    
                    Text("${model.main!.temp!.round()}$degree$celsius",style: TextStyle(color: Colors.white)),
                    Text("${model.weather![0].description}",style: TextStyle(color: Colors.white,fontSize: 13)),
                    Text("${model.main!.tempMin!.round()}$degree$celsius / ${model.main!.tempMax!.round()}$degree$celsius",style: TextStyle(color: Colors.white,fontSize: 13)),

                    
                  ],
                ),
                margin: EdgeInsets.all(5),
                height: 220,
                width: 135,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15)),
              );
            },
          ),
        )
      ],
    );
  }
}

class _citySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
        onPressed: () {
          close(context, '');
        },
        icon: Icon(Icons.clear));
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.search),
      title: Text(query),
      onTap: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredList = query.isEmpty
        ? cities
        : cities
            .where((city) => city.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(filteredList[index]),
        onTap: () {
          query = filteredList[index];
          close(context, query);
        },
      ),
    );
  }
}

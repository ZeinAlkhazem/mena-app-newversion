import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter/widgets.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../models/my_models/weather_model.dart';


class PopupWidgetUpComing extends StatefulWidget {
  final String? data;

  PopupWidgetUpComing(this.data);

  @override
  State<PopupWidgetUpComing> createState() => _PopupWidgetUpComingState();
}

class _PopupWidgetUpComingState extends State<PopupWidgetUpComing> {
  var x;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weatherStatusTitle;

    weatherLargeIcon1;

    weatherSmallIcon1;
  }

  List weatherCodeList = [
    WeatherModel(
        id: 1,
        title: "Clear, Sunny",
        weatherLargeIcon: "assets/new_icons/large/png/10000_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/10000_clear_small.png"),
    WeatherModel(
        id: 2,
        title: "Mostly Clear",
        weatherLargeIcon: "assets/new_icons/large/png/11000_mostly_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/11000_mostly_clear_small.png"),
    WeatherModel(
        id: 3,
        title: "Partly Cloudy",
        weatherLargeIcon: "assets/new_icons/large/png/11010_partly_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/11010_partly_cloudy_small.png"),
    WeatherModel(
        id: 4,
        title: "Mostly Cloudy",
        weatherLargeIcon: "assets/new_icons/large/png/11020_mostly_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/11020_mostly_cloudy_small.png"),
    WeatherModel(
        id: 5,
        title: "Cloudy",
        weatherLargeIcon: "assets/new_icons/large/png/10010_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/10010_cloudy_small.png"),
    WeatherModel(
        id: 6,
        title: "Fog",
        weatherLargeIcon: "assets/new_icons/large/png/20000_fog_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/20000_fog_small.png"),
    WeatherModel(
        id: 7,
        title: "Light Fog",
        weatherLargeIcon: "assets/new_icons/large/png/21000_fog_light_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/21000_fog_light_small.png"),
    WeatherModel(
        id: 8,
        title: "Drizzle",
        weatherLargeIcon: "assets/new_icons/large/png/40000_drizzle_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/40000_drizzle_small.png"),
    WeatherModel(
        id: 9,
        title: "Rain",
        weatherLargeIcon: "assets/new_icons/large/png/40010_rain_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/40010_rain_small.png"),
    WeatherModel(
        id: 10,
        title: "Light Rain",
        weatherLargeIcon: "assets/new_icons/large/png/42000_rain_light_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/42000_rain_light_small.png"),
    WeatherModel(
        id: 11,
        title: "Heavy Rain",
        weatherLargeIcon: "assets/new_icons/large/png/42010_rain_heavy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/42010_rain_heavy_small.png"),
    WeatherModel(
        id: 12,
        title: "Snow",
        weatherLargeIcon: "assets/new_icons/large/png/50000_snow_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/50000_snow_small.png"),
    WeatherModel(
        id: 13,
        title: "Flurries",
        weatherLargeIcon: "assets/new_icons/large/png/51150_flurries_mostly_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/51150_flurries_mostly_clear_small.png"),
    WeatherModel(
        id: 14,
        title: "Light Snow",
        weatherLargeIcon: "assets/new_icons/large/png/51030_snow_light_partly_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/51030_snow_light_partly_cloudy_small.png"),
    WeatherModel(
        id: 15,
        title: "Heavy Snow",
        weatherLargeIcon: "assets/new_icons/large/png/51190_snow_heavy_mostly_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/51190_snow_heavy_mostly_clear_small.png"),
    WeatherModel(
        id: 16,
        title: "Freezing Drizzle",
        weatherLargeIcon: "assets/new_icons/large/png/10000_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/10000_clear_large.png"),
    WeatherModel(
        id: 17,
        title: "Freezing Rain",
        weatherLargeIcon: "assets/new_icons/large/png/10000_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/10000_clear_large.png"),
    WeatherModel(
        id: 18,
        title: "Light Freezing Rain",
        weatherLargeIcon: "assets/new_icons/large/png/62000_freezing_rain_light_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/62000_freezing_rain_light_small.png"),
    WeatherModel(
        id: 19,
        title: "Heavy Freezing Rain",
        weatherLargeIcon: "assets/new_icons/large/png/62010_freezing_rain_heavy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/62010_freezing_rain_heavy_small.png"),
    WeatherModel(
        id: 20,
        title: "Ice Pellets",
        weatherLargeIcon: "assets/new_icons/large/png/70000_ice_pellets_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/70000_ice_pellets_small.png"),
    WeatherModel(
        id: 21,
        title: "Heavy Ice Pellets",
        weatherLargeIcon: "assets/new_icons/large/png/71010_ice_pellets_heavy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/71010_ice_pellets_heavy_small.png"),
    WeatherModel(
        id: 22,
        title: "Light Ice Pellets",
        weatherLargeIcon: "assets/new_icons/large/png/71020_ice_pellets_light_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/71020_ice_pellets_light_small.png"),
    WeatherModel(
        id: 23,
        title: "Thunderstorm",
        weatherLargeIcon: "assets/new_icons/large/png/80020_tstorm_mostly_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/80020_tstorm_mostly_cloudy_small.png"),
  ];

  String weatherStatusTitle = '';

  String weatherLargeIcon1 = '';

  String weatherSmallIcon1 = '';

  Future<Map<String, dynamic>> fetchWeatherData(String location) async {
    final apiKey = '626v6P68Jw7bdXIBWU14bx2WMQXFdcmF'; // Replace with your API key
    final apiUrl =
        'https://api.tomorrow.io/v4/weather/forecast?location=$location&timesteps=1d&apikey=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    var data =
        json.decode(response.body);
    log("# Data weather response : $data");
    ///temperatureAvg
    if (response.statusCode == 200) {
      return data ;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchWeatherData(widget.data!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final Map<String, dynamic>? responseData = snapshot.data as Map<String, dynamic>?;

          if (responseData == null) {
            return Text('Error: No data available.');
          }

          final List<dynamic>? dailyData = responseData['timelines']['daily'];
          if (dailyData == null || dailyData.isEmpty) {
            return Text('Error: No daily data available.');
          }
          Map<String, dynamic>? values = dailyData[0]['values'];
          if (values == null) {
            // Handle the case where values are null
            return Container();
          }
          String weatherStatus = '';
          String weatherSmallIcon = '';
          String weatherLargeIcon = '';

          switch(values['weatherCodeMin'].toString()){
            case '1000':
              weatherStatus = weatherCodeList[1].title;
              weatherSmallIcon = weatherCodeList[1].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[1].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '1100':
              weatherStatus = weatherCodeList[2].title;
              weatherSmallIcon = weatherCodeList[2].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[2].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '1101':
              weatherStatus = weatherCodeList[3].title;
              weatherSmallIcon = weatherCodeList[3].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[3].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '1102':
              weatherStatus = weatherCodeList[4].title;
              weatherSmallIcon = weatherCodeList[4].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[4].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '1001':
              log("# weather code111 ---- :${values['weatherCodeMin']} ");
              weatherStatus = weatherCodeList[5].title;
              weatherSmallIcon = weatherCodeList[5].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[5].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              log("# weather large Icon ---- :${weatherLargeIcon1} ");
              log("# weather status 222 ---- :${weatherStatusTitle} ");
              break;
            case '2000':
              weatherStatus = weatherCodeList[6].title;
              weatherSmallIcon = weatherCodeList[6].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[6].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '2100':
              weatherStatus = weatherCodeList[7].title;
              weatherSmallIcon = weatherCodeList[7].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[7].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '4000':
              weatherStatus = weatherCodeList[8].title;
              weatherSmallIcon = weatherCodeList[8].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[8].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '4001':
              weatherStatus = weatherCodeList[9].title;
              weatherSmallIcon = weatherCodeList[9].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[9].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '4200':
              weatherStatus = weatherCodeList[10].title;
              weatherSmallIcon = weatherCodeList[10].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[10].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '4201':
              weatherStatus = weatherCodeList[11].title;
              weatherSmallIcon = weatherCodeList[11].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[11].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '5000':
              weatherStatus = weatherCodeList[12].title;
              weatherSmallIcon = weatherCodeList[12].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[12].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '5001':
              weatherStatus = weatherCodeList[13].title;
              weatherSmallIcon = weatherCodeList[13].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[13].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '5100':
              weatherStatus = weatherCodeList[14].title;
              weatherSmallIcon = weatherCodeList[14].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[14].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '5101':
              weatherStatus = weatherCodeList[15].title;
              weatherSmallIcon = weatherCodeList[15].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[15].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '6000':
              weatherStatus = weatherCodeList[16].title;
              weatherSmallIcon = weatherCodeList[16].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[16].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '6001':
              weatherStatus = weatherCodeList[17].title;
              weatherSmallIcon = weatherCodeList[17].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[17].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '6200':
              weatherStatus = weatherCodeList[18].title;
              weatherSmallIcon = weatherCodeList[18].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[18].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '6201':
              weatherStatus = weatherCodeList[19].title;
              weatherSmallIcon = weatherCodeList[19].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[19].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '7000':
              weatherStatus = weatherCodeList[20].title;
              weatherSmallIcon = weatherCodeList[20].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[20].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '7101':
              weatherStatus = weatherCodeList[21].title;
              weatherSmallIcon = weatherCodeList[21].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[21].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '7102':
              weatherStatus = weatherCodeList[22].title;
              weatherSmallIcon = weatherCodeList[22].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[22].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            case '8000':
              weatherStatus = weatherCodeList[23].title;
              weatherSmallIcon = weatherCodeList[23].weatherSmallIcon;
              weatherLargeIcon = weatherCodeList[23].weatherLargeIcon;
              weatherStatusTitle = weatherStatus;
              weatherLargeIcon1 = weatherLargeIcon;
              weatherSmallIcon1 = weatherSmallIcon;
              break;
            default:
              weatherStatus = 'Unknown';
              weatherSmallIcon = '';
              weatherLargeIcon = '';
              break;
          }



          // Extracting relevant information
          String locationName = widget.data!;
          String countryName = "Country"; // Replace with actual country name
          log("# location name : $locationName");
          log("# weather large up ---- :${weatherLargeIcon1} ");
          log("# weather status up ---- :${weatherStatusTitle} ");
          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: 330,
                height: 510,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xffFFFFFF),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29000000),
                      offset: Offset(0, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Location icon and country name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Color(0xff97A0A8),
                            size: 18,
                          ),
                        ),
                        Text(
                          '$locationName',
                          style: TextStyle(
                            color: Color(0xff97A0A8),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 5,bottom: 2),
                          width: 90.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow:  null),
                          child: Image.asset(
                            weatherLargeIcon1!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            '${dailyData[0]['values']["temperatureAvg"]}°',
                            style: TextStyle(
                              color: Color(0xff050505),
                              fontSize: 45.0,
                              // fontWeight: FontWeight.w600,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              weatherStatusTitle!,
                              style: TextStyle(
                                color: Color(0xff050505),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            Text(
                              'feels like ${dailyData[0]['values']["temperatureApparentAvg"]}°',
                              style: TextStyle(
                                color: Color(0xff050505),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Loop through all days in dailyData
                    for (var dayData in dailyData)
                      _buildDayInfo(dayData),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildDayInfo(dynamic dayData) {
    DateTime? date = DateTime.tryParse(dayData['time'] ?? '');
    if (date == null) {
      // Handle the case where the date is null
      return Container();
    }

    String dayName = DateFormat.EEEE().format(date); // Day name
    int dayNumber = date.day; // Day number

    Map<String, dynamic>? values = dayData['values'];
    if (values == null) {
      // Handle the case where values are null
      return Container();
    }
    log("# temperatureAvg :${values['temperatureAvg']} ");
    log("# temperatureMax :${values['temperatureMax']} ");
    log("# temperatureMin :${values['temperatureMin']} ");

    double temperatureAvg = values['temperatureAvg'].toDouble() ?? 0.0;
    double temperatureMax = values['temperatureMax'].toDouble() ?? 0.0;
    double temperatureMin = values['temperatureMin'].toDouble() ?? 0.0;
    double rainIntensityAvg = values['precipitationIntensity'] ?? 0.0;
    String weatherStatus = '';
    String weatherSmallIcon = '';
    String weatherLargeIcon = '';

    switch(values['weatherCodeMin'].toString()){
      case '1000':
        weatherStatus = weatherCodeList[1].title;
        weatherSmallIcon = weatherCodeList[1].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[1].weatherLargeIcon;
          weatherStatusTitle = weatherStatus;
          weatherLargeIcon1 = weatherLargeIcon;
          weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '1100':
        weatherStatus = weatherCodeList[2].title;
        weatherSmallIcon = weatherCodeList[2].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[2].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '1101':
        weatherStatus = weatherCodeList[3].title;
        weatherSmallIcon = weatherCodeList[3].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[3].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '1102':
        weatherStatus = weatherCodeList[4].title;
        weatherSmallIcon = weatherCodeList[4].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[4].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '1001':
        log("# weather code111 ---- :${values['weatherCodeMin']} ");
        weatherStatus = weatherCodeList[5].title;
        weatherSmallIcon = weatherCodeList[5].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[5].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        log("# weather large Icon ---- :${weatherLargeIcon1} ");
        log("# weather status 222 ---- :${weatherStatusTitle} ");
        break;
      case '2000':
        weatherStatus = weatherCodeList[6].title;
        weatherSmallIcon = weatherCodeList[6].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[6].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '2100':
        weatherStatus = weatherCodeList[7].title;
        weatherSmallIcon = weatherCodeList[7].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[7].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '4000':
        weatherStatus = weatherCodeList[8].title;
        weatherSmallIcon = weatherCodeList[8].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[8].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '4001':
        weatherStatus = weatherCodeList[9].title;
        weatherSmallIcon = weatherCodeList[9].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[9].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '4200':
        weatherStatus = weatherCodeList[10].title;
        weatherSmallIcon = weatherCodeList[10].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[10].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '4201':
        weatherStatus = weatherCodeList[11].title;
        weatherSmallIcon = weatherCodeList[11].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[11].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '5000':
        weatherStatus = weatherCodeList[12].title;
        weatherSmallIcon = weatherCodeList[12].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[12].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '5001':
        weatherStatus = weatherCodeList[13].title;
        weatherSmallIcon = weatherCodeList[13].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[13].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '5100':
        weatherStatus = weatherCodeList[14].title;
        weatherSmallIcon = weatherCodeList[14].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[14].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '5101':
        weatherStatus = weatherCodeList[15].title;
        weatherSmallIcon = weatherCodeList[15].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[15].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '6000':
        weatherStatus = weatherCodeList[16].title;
        weatherSmallIcon = weatherCodeList[16].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[16].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '6001':
        weatherStatus = weatherCodeList[17].title;
        weatherSmallIcon = weatherCodeList[17].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[17].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '6200':
        weatherStatus = weatherCodeList[18].title;
        weatherSmallIcon = weatherCodeList[18].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[18].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '6201':
        weatherStatus = weatherCodeList[19].title;
        weatherSmallIcon = weatherCodeList[19].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[19].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '7000':
        weatherStatus = weatherCodeList[20].title;
        weatherSmallIcon = weatherCodeList[20].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[20].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '7101':
        weatherStatus = weatherCodeList[21].title;
        weatherSmallIcon = weatherCodeList[21].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[21].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '7102':
        weatherStatus = weatherCodeList[22].title;
        weatherSmallIcon = weatherCodeList[22].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[22].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      case '8000':
        weatherStatus = weatherCodeList[23].title;
        weatherSmallIcon = weatherCodeList[23].weatherSmallIcon;
        weatherLargeIcon = weatherCodeList[23].weatherLargeIcon;
        weatherStatusTitle = weatherStatus;
        weatherLargeIcon1 = weatherLargeIcon;
        weatherSmallIcon1 = weatherSmallIcon;
        break;
      default:
        weatherStatus = 'Unknown';
        weatherSmallIcon = '';
        weatherLargeIcon = '';
        break;
    }

    return Container(
      padding: EdgeInsets.only(right: 10,left: 10),
      child: Column(
        children: [
          SizedBox(height: 20),
          // Big icon with temperature and weather condition
          // SizedBox(height: 20),
          // Daily forecast for each day
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      '$dayName'.substring(0, 3),
                      style: TextStyle(
                        color: Color(0xff97A0A8),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Text(
                      '$dayNumber',
                      style: TextStyle(
                        color: Color(0xff050505),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
              widthBox(30.w),
              Container(
                // padding: EdgeInsets.only(left: 30),
                child: Image.asset(
                  weatherSmallIcon1!,
                  fit: BoxFit.contain,
                ),
              ),
              widthBox(30.w),
              Container(
                // padding: EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Icon(
                      Icons.umbrella,
                      color: Color(0xff97A0A8),
                    ),
                    widthBox(1.w),
                    Text(
                      '$rainIntensityAvg%',
                      style: TextStyle(
                        color: Color(0xff97A0A8),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
              widthBox(30.w),
              Container(
                // padding: EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      ' $temperatureMin° ',
                      style: TextStyle(
                        color: Color(0xff97A0A8),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Text(
                      '$temperatureMax°',
                      style: TextStyle(
                        color: Color(0xff050505),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///


class PopupWidgetAir extends StatefulWidget {
  final String? data;

  PopupWidgetAir(this.data);

  @override
  State<PopupWidgetAir> createState() => _PopupWidgetAirState();
}

class _PopupWidgetAirState extends State<PopupWidgetAir> {
  double value1 = 40.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weatherStatusTitle;

    weatherLargeIcon1;

    weatherSmallIcon1;
  }

  List weatherCodeList = [
    WeatherModel(
        id: 1,
        title: "Clear, Sunny",
        weatherLargeIcon: "assets/new_icons/large/png/10000_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/10000_clear_small.png"),
    WeatherModel(
        id: 2,
        title: "Mostly Clear",
        weatherLargeIcon: "assets/new_icons/large/png/11000_mostly_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/11000_mostly_clear_small.png"),
    WeatherModel(
        id: 3,
        title: "Partly Cloudy",
        weatherLargeIcon: "assets/new_icons/large/png/11010_partly_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/11010_partly_cloudy_small.png"),
    WeatherModel(
        id: 4,
        title: "Mostly Cloudy",
        weatherLargeIcon: "assets/new_icons/large/png/11020_mostly_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/11020_mostly_cloudy_small.png"),
    WeatherModel(
        id: 5,
        title: "Cloudy",
        weatherLargeIcon: "assets/new_icons/large/png/10010_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/10010_cloudy_small.png"),
    WeatherModel(
        id: 6,
        title: "Fog",
        weatherLargeIcon: "assets/new_icons/large/png/20000_fog_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/20000_fog_small.png"),
    WeatherModel(
        id: 7,
        title: "Light Fog",
        weatherLargeIcon: "assets/new_icons/large/png/21000_fog_light_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/21000_fog_light_small.png"),
    WeatherModel(
        id: 8,
        title: "Drizzle",
        weatherLargeIcon: "assets/new_icons/large/png/40000_drizzle_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/40000_drizzle_small.png"),
    WeatherModel(
        id: 9,
        title: "Rain",
        weatherLargeIcon: "assets/new_icons/large/png/40010_rain_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/40010_rain_small.png"),
    WeatherModel(
        id: 10,
        title: "Light Rain",
        weatherLargeIcon: "assets/new_icons/large/png/42000_rain_light_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/42000_rain_light_small.png"),
    WeatherModel(
        id: 11,
        title: "Heavy Rain",
        weatherLargeIcon: "assets/new_icons/large/png/42010_rain_heavy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/42010_rain_heavy_small.png"),
    WeatherModel(
        id: 12,
        title: "Snow",
        weatherLargeIcon: "assets/new_icons/large/png/50000_snow_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/50000_snow_small.png"),
    WeatherModel(
        id: 13,
        title: "Flurries",
        weatherLargeIcon: "assets/new_icons/large/png/51150_flurries_mostly_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/51150_flurries_mostly_clear_small.png"),
    WeatherModel(
        id: 14,
        title: "Light Snow",
        weatherLargeIcon: "assets/new_icons/large/png/51030_snow_light_partly_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/51030_snow_light_partly_cloudy_small.png"),
    WeatherModel(
        id: 15,
        title: "Heavy Snow",
        weatherLargeIcon: "assets/new_icons/large/png/51190_snow_heavy_mostly_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/51190_snow_heavy_mostly_clear_small.png"),
    WeatherModel(
        id: 16,
        title: "Freezing Drizzle",
        weatherLargeIcon: "assets/new_icons/large/png/10000_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/10000_clear_large.png"),
    WeatherModel(
        id: 17,
        title: "Freezing Rain",
        weatherLargeIcon: "assets/new_icons/large/png/10000_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/10000_clear_large.png"),
    WeatherModel(
        id: 18,
        title: "Light Freezing Rain",
        weatherLargeIcon: "assets/new_icons/large/png/62000_freezing_rain_light_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/62000_freezing_rain_light_small.png"),
    WeatherModel(
        id: 19,
        title: "Heavy Freezing Rain",
        weatherLargeIcon: "assets/new_icons/large/png/62010_freezing_rain_heavy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/62010_freezing_rain_heavy_small.png"),
    WeatherModel(
        id: 20,
        title: "Ice Pellets",
        weatherLargeIcon: "assets/new_icons/large/png/70000_ice_pellets_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/70000_ice_pellets_small.png"),
    WeatherModel(
        id: 21,
        title: "Heavy Ice Pellets",
        weatherLargeIcon: "assets/new_icons/large/png/71010_ice_pellets_heavy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/71010_ice_pellets_heavy_small.png"),
    WeatherModel(
        id: 22,
        title: "Light Ice Pellets",
        weatherLargeIcon: "assets/new_icons/large/png/71020_ice_pellets_light_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/71020_ice_pellets_light_small.png"),
    WeatherModel(
        id: 23,
        title: "Thunderstorm",
        weatherLargeIcon: "assets/new_icons/large/png/80020_tstorm_mostly_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/80020_tstorm_mostly_cloudy_small.png"),
  ];

  String weatherStatusTitle = '';

  String weatherLargeIcon1 = '';

  String weatherSmallIcon1 = '';

  // Function to create a linear gradient
  BoxDecoration buildGradientBackground() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      boxShadow: const [
        BoxShadow(
          color: Color(0x29000000),
          offset: Offset(0, 2),
          blurRadius: 3,
        ),
      ],
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xffBCF1FD), // Color for the first third of the screen from the top
          Color(0xffFDFDFD),
          Colors.white,// Color for the remaining two-thirds of the screen
        ],
        stops: [0,0.4, 1.0], // Divide the screen into thirds
      ),
    );
  }

  Future<Map<String, dynamic>> fetchWeatherData(String location) async {
    final apiKey = 'UNdeVStXE4TBU4BAXQeAve0Tb8ZAU8bG'; // Replace with your API key
    final apiUrl =
        'https://api.tomorrow.io/v4/weather/forecast?location=$location&timesteps=1d&apikey=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    var data =
    json.decode(response.body);
    log("# Data weather response : $data");
    ///temperatureAvg
    if (response.statusCode == 200) {
      return data ;
    } else {
      throw Exception('Failed to load weather data');
    }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchWeatherData(widget.data!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final Map<String, dynamic>? responseData = snapshot.data as Map<String, dynamic>?;

            if (responseData == null) {
              return Text('Error: No data available.');
            }

            final List<dynamic>? dailyData = responseData['timelines']['daily'];

            if (dailyData == null || dailyData.isEmpty) {
              return Text('Error: No daily data available.');
            }
            Map<String, dynamic>? values = dailyData[0]['values'];
            if (values == null) {
              // Handle the case where values are null
              return Container();
            }
            String airQuality = '';
            String weatherStatus = '';
            String weatherSmallIcon = '';
            String weatherLargeIcon = '';


            switch(values['weatherCodeMin'].toString()){
              case '1000':
                weatherStatus = weatherCodeList[1].title;
                weatherSmallIcon = weatherCodeList[1].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[1].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '1100':
                weatherStatus = weatherCodeList[2].title;
                weatherSmallIcon = weatherCodeList[2].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[2].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '1101':
                weatherStatus = weatherCodeList[3].title;
                weatherSmallIcon = weatherCodeList[3].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[3].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '1102':
                weatherStatus = weatherCodeList[4].title;
                weatherSmallIcon = weatherCodeList[4].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[4].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '1001':
                log("# weather code111 ---- :${values['weatherCodeMin']} ");
                weatherStatus = weatherCodeList[5].title;
                weatherSmallIcon = weatherCodeList[5].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[5].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                log("# weather large Icon ---- :${weatherLargeIcon1} ");
                log("# weather status 222 ---- :${weatherStatusTitle} ");
                break;
              case '2000':
                weatherStatus = weatherCodeList[6].title;
                weatherSmallIcon = weatherCodeList[6].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[6].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '2100':
                weatherStatus = weatherCodeList[7].title;
                weatherSmallIcon = weatherCodeList[7].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[7].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '4000':
                weatherStatus = weatherCodeList[8].title;
                weatherSmallIcon = weatherCodeList[8].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[8].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '4001':
                weatherStatus = weatherCodeList[9].title;
                weatherSmallIcon = weatherCodeList[9].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[9].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '4200':
                weatherStatus = weatherCodeList[10].title;
                weatherSmallIcon = weatherCodeList[10].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[10].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '4201':
                weatherStatus = weatherCodeList[11].title;
                weatherSmallIcon = weatherCodeList[11].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[11].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '5000':
                weatherStatus = weatherCodeList[12].title;
                weatherSmallIcon = weatherCodeList[12].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[12].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '5001':
                weatherStatus = weatherCodeList[13].title;
                weatherSmallIcon = weatherCodeList[13].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[13].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '5100':
                weatherStatus = weatherCodeList[14].title;
                weatherSmallIcon = weatherCodeList[14].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[14].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '5101':
                weatherStatus = weatherCodeList[15].title;
                weatherSmallIcon = weatherCodeList[15].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[15].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '6000':
                weatherStatus = weatherCodeList[16].title;
                weatherSmallIcon = weatherCodeList[16].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[16].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '6001':
                weatherStatus = weatherCodeList[17].title;
                weatherSmallIcon = weatherCodeList[17].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[17].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '6200':
                weatherStatus = weatherCodeList[18].title;
                weatherSmallIcon = weatherCodeList[18].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[18].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '6201':
                weatherStatus = weatherCodeList[19].title;
                weatherSmallIcon = weatherCodeList[19].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[19].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '7000':
                weatherStatus = weatherCodeList[20].title;
                weatherSmallIcon = weatherCodeList[20].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[20].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '7101':
                weatherStatus = weatherCodeList[21].title;
                weatherSmallIcon = weatherCodeList[21].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[21].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '7102':
                weatherStatus = weatherCodeList[22].title;
                weatherSmallIcon = weatherCodeList[22].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[22].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '8000':
                weatherStatus = weatherCodeList[23].title;
                weatherSmallIcon = weatherCodeList[23].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[23].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              default:
                weatherStatus = 'Unknown';
                weatherSmallIcon = '';
                weatherLargeIcon = '';
                break;
            }

            // Extracting relevant information
            String locationName = widget.data!;
            String countryName = "Country"; // Replace with actual country name
            log("# location name : $locationName");
            return Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 330,
                  height: 500,
                  decoration: buildGradientBackground(),
                  // BoxDecoration(
                  //   borderRadius: BorderRadius.circular(30),
                  //   color: Color(0xffFFFFFF),
                  //   boxShadow: const [
                  //     BoxShadow(
                  //       color: Color(0x29000000),
                  //       offset: Offset(0, 2),
                  //       blurRadius: 3,
                  //     ),
                  //   ],
                  // ),
                  padding: EdgeInsets.only(left:16, right: 16,top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Location icon and country name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Now',
                                  style: TextStyle(
                                    color: Color(0xff050505),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 60,top: 20),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xff97A0A8),
                                    size: 18,
                                  ),
                                ),
                                Text(
                                  '$locationName',
                                  style: TextStyle(
                                    color: Color(0xff97A0A8),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 5,bottom: 2),
                            width: 90.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                boxShadow:  null),
                            child: Image.asset(
                              weatherLargeIcon1!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              '${dailyData[0]['values']["temperatureAvg"]}°',
                              style: TextStyle(
                                color: Color(0xff050505),
                                fontSize: 45.0,
                                // fontWeight: FontWeight.w600,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                weatherStatusTitle,
                                style: TextStyle(
                                  color: Color(0xff050505),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              Text(
                                'feels like ${dailyData[0]['values']["temperatureApparentAvg"]}°',
                                style: TextStyle(
                                  color: Color(0xff050505),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(color: Color(0xff97A0A8),),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                'Air quality',
                                style: TextStyle(
                                  color: Color(0xff050505),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              Text(
                                'Good',
                                style: TextStyle(
                                  color: Color(0xff97A0A8),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: new LinearPercentIndicator(
                                  width: 200.0,
                                  backgroundColor: Color(0xffccf4fd).withOpacity(0.5),
                                  barRadius: Radius.circular(15),
                                  lineHeight: 15.0,
                                  percent: dailyData[0]['values']["windSpeedAvg"]/10,
                                  linearGradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xffCADF91).withOpacity(0.5), // Color for the first third of the screen from the top
                                      Color(0xffCADF91), // Color for the remaining two-thirds of the screen
                                    ],
                                    stops: [0,0.5], // Divide the screen into thirds
                                  ),
                                  // progressColor: Color(0xffc5de87),
                                ),
                              ),
                              heightBox(5.h),
                              Text(
                                '   0    100    200     300     400     500',
                                style: TextStyle(
                                  color: Color(0xff97A0A8),
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(color: Color(0xff97A0A8),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'Pollen',
                              style: TextStyle(
                                color: Color(0xff050505),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ],
                      ),
                      heightBox(14.h),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                'Tree',
                                style: TextStyle(
                                  color: Color(0xff050505),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              Text(
                                '0/5',
                                style: TextStyle(
                                  color: Color(0xff97A0A8),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 36),
                                child: new LinearPercentIndicator(
                                  width: 215.0,
                                  backgroundColor: Color(0xffccf4fd).withOpacity(0.5),
                                  barRadius: Radius.circular(15),
                                  lineHeight: 9.0,
                                  percent: dailyData[0]['values']["windSpeedMin"]/10,
                                  linearGradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xffCADF91).withOpacity(0.5), // Color for the first third of the screen from the top
                                      Color(0xffCADF91), // Color for the remaining two-thirds of the screen
                                    ],
                                    stops: [0,0.5], // Divide the screen into thirds
                                  ),
                                  // progressColor: Color(0xffc5de87),
                                ),
                              ),
                              heightBox(5.h),
                              Padding(
                                padding: const EdgeInsets.only(left:31.0),
                                child: Text(
                                  '0         1          2          3          4          5',
                                  style: TextStyle(
                                    color: Color(0xff97A0A8),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      heightBox(14.h),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                'Weed',
                                style: TextStyle(
                                  color: Color(0xff050505),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              Text(
                                '0/5',
                                style: TextStyle(
                                  color: Color(0xff97A0A8),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 30),
                                child: new LinearPercentIndicator(
                                  width: 215.0,
                                  backgroundColor: Color(0xffccf4fd).withOpacity(0.5),
                                  barRadius: Radius.circular(15),
                                  lineHeight: 9.0,
                                  percent: dailyData[0]['values']["windSpeedMax"]/10,
                                  linearGradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xffCADF91).withOpacity(0.5), // Color for the first third of the screen from the top
                                      Color(0xffCADF91), // Color for the remaining two-thirds of the screen
                                    ],
                                    stops: [0,0.5], // Divide the screen into thirds
                                  ),
                                  // progressColor: Color(0xffc5de87),
                                ),
                              ),
                              heightBox(5.h),
                              Padding(
                                padding: const EdgeInsets.only(left:31.0),
                                child: Text(
                                  '0         1          2          3          4          5',
                                  style: TextStyle(
                                    color: Color(0xff97A0A8),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      heightBox(14.h),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                'Grass',
                                style: TextStyle(
                                  color: Color(0xff050505),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              Text(
                                '0/5',
                                style: TextStyle(
                                  color: Color(0xff97A0A8),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 30),
                                child: new LinearPercentIndicator(
                                  width: 215.0,
                                  backgroundColor: Color(0xffccf4fd).withOpacity(0.5),
                                  barRadius: Radius.circular(15),
                                  lineHeight: 9.0,
                                  percent: dailyData[0]['values']["windGustMin"]/10,
                                  linearGradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xffCADF91).withOpacity(0.5), // Color for the first third of the screen from the top
                                      Color(0xffCADF91), // Color for the remaining two-thirds of the screen
                                    ],
                                    stops: [0,0.5], // Divide the screen into thirds
                                  ),
                                  // progressColor: Color(0xffc5de87),
                                ),
                              ),
                              heightBox(5.h),
                              Padding(
                                padding: const EdgeInsets.only(left:31.0),
                                child: Text(
                                  '0         1          2          3          4          5',
                                  style: TextStyle(
                                    color: Color(0xff97A0A8),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      );

  }
}


///

class PopupWidgetSummary extends StatefulWidget {
  final String? data;

  PopupWidgetSummary(this.data);

  @override
  State<PopupWidgetSummary> createState() => _PopupWidgetSummaryState();
}

class _PopupWidgetSummaryState extends State<PopupWidgetSummary> {
  final player = AudioPlayer();
  late WebViewController _webViewController;
  bool isPlaying = false;

  Duration duration = Duration.zero;

  Duration position = Duration.zero;


  List weatherCodeList = [
    WeatherModel(
        id: 1,
        title: "Clear, Sunny",
        weatherLargeIcon: "assets/new_icons/large/png/10000_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/10000_clear_small.png"),
    WeatherModel(
        id: 2,
        title: "Mostly Clear",
        weatherLargeIcon: "assets/new_icons/large/png/11000_mostly_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/11000_mostly_clear_small.png"),
    WeatherModel(
        id: 3,
        title: "Partly Cloudy",
        weatherLargeIcon: "assets/new_icons/large/png/11010_partly_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/11010_partly_cloudy_small.png"),
    WeatherModel(
        id: 4,
        title: "Mostly Cloudy",
        weatherLargeIcon: "assets/new_icons/large/png/11020_mostly_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/11020_mostly_cloudy_small.png"),
    WeatherModel(
        id: 5,
        title: "Cloudy",
        weatherLargeIcon: "assets/new_icons/large/png/10010_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/10010_cloudy_small.png"),
    WeatherModel(
        id: 6,
        title: "Fog",
        weatherLargeIcon: "assets/new_icons/large/png/20000_fog_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/20000_fog_small.png"),
    WeatherModel(
        id: 7,
        title: "Light Fog",
        weatherLargeIcon: "assets/new_icons/large/png/21000_fog_light_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/21000_fog_light_small.png"),
    WeatherModel(
        id: 8,
        title: "Drizzle",
        weatherLargeIcon: "assets/new_icons/large/png/40000_drizzle_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/40000_drizzle_small.png"),
    WeatherModel(
        id: 9,
        title: "Rain",
        weatherLargeIcon: "assets/new_icons/large/png/40010_rain_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/40010_rain_small.png"),
    WeatherModel(
        id: 10,
        title: "Light Rain",
        weatherLargeIcon: "assets/new_icons/large/png/42000_rain_light_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/42000_rain_light_small.png"),
    WeatherModel(
        id: 11,
        title: "Heavy Rain",
        weatherLargeIcon: "assets/new_icons/large/png/42010_rain_heavy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/42010_rain_heavy_small.png"),
    WeatherModel(
        id: 12,
        title: "Snow",
        weatherLargeIcon: "assets/new_icons/large/png/50000_snow_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/50000_snow_small.png"),
    WeatherModel(
        id: 13,
        title: "Flurries",
        weatherLargeIcon: "assets/new_icons/large/png/51150_flurries_mostly_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/51150_flurries_mostly_clear_small.png"),
    WeatherModel(
        id: 14,
        title: "Light Snow",
        weatherLargeIcon: "assets/new_icons/large/png/51030_snow_light_partly_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/51030_snow_light_partly_cloudy_small.png"),
    WeatherModel(
        id: 15,
        title: "Heavy Snow",
        weatherLargeIcon: "assets/new_icons/large/png/51190_snow_heavy_mostly_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/51190_snow_heavy_mostly_clear_small.png"),
    WeatherModel(
        id: 16,
        title: "Freezing Drizzle",
        weatherLargeIcon: "assets/new_icons/large/png/10000_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/10000_clear_large.png"),
    WeatherModel(
        id: 17,
        title: "Freezing Rain",
        weatherLargeIcon: "assets/new_icons/large/png/10000_clear_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/10000_clear_large.png"),
    WeatherModel(
        id: 18,
        title: "Light Freezing Rain",
        weatherLargeIcon: "assets/new_icons/large/png/62000_freezing_rain_light_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/62000_freezing_rain_light_small.png"),
    WeatherModel(
        id: 19,
        title: "Heavy Freezing Rain",
        weatherLargeIcon: "assets/new_icons/large/png/62010_freezing_rain_heavy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/62010_freezing_rain_heavy_small.png"),
    WeatherModel(
        id: 20,
        title: "Ice Pellets",
        weatherLargeIcon: "assets/new_icons/large/png/70000_ice_pellets_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/70000_ice_pellets_small.png"),
    WeatherModel(
        id: 21,
        title: "Heavy Ice Pellets",
        weatherLargeIcon: "assets/new_icons/large/png/71010_ice_pellets_heavy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/71010_ice_pellets_heavy_small.png"),
    WeatherModel(
        id: 22,
        title: "Light Ice Pellets",
        weatherLargeIcon: "assets/new_icons/large/png/71020_ice_pellets_light_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/71020_ice_pellets_light_small.png"),
    WeatherModel(
        id: 23,
        title: "Thunderstorm",
        weatherLargeIcon: "assets/new_icons/large/png/80020_tstorm_mostly_cloudy_large.png",
        weatherSmallIcon: "assets/new_icons/small/png/80020_tstorm_mostly_cloudy_small.png"),
  ];

  String weatherStatusTitle = '';

  String weatherLargeIcon1 = '';

  String weatherSmallIcon1 = '';

  @override
  void initState(){
    super.initState();
    weatherStatusTitle;
    weatherLargeIcon1;
    weatherSmallIcon1;
    player.onPlayerStateChanged.listen((state){
      setState((){
        isPlaying = state == PlayerState.playing;
      });
    });
    player.onDurationChanged.listen((newDuration){
      setState((){
        duration = newDuration;
      });
    });
    player.onPositionChanged.listen((newPosition){
      setState((){
        position = newPosition;
      });
    });
  }

  Future<Map<String, dynamic>> fetchWeatherData(String location) async {
    final apiKey = '626v6P68Jw7bdXIBWU14bx2WMQXFdcmF'; // Replace with your API key
    final apiUrl =
        'https://api.tomorrow.io/v4/weather/forecast?location=$location&timesteps=1d&apikey=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    var data =
    json.decode(response.body);
    log("# Data weather response : $data");
    ///temperatureAvg
    if (response.statusCode == 200) {
      return data ;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: fetchWeatherData(widget.data!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final Map<String, dynamic>? responseData = snapshot.data as Map<String, dynamic>?;

            if (responseData == null) {
              return Text('Error: No data available.');
            }

            final List<dynamic>? dailyData = responseData['timelines']['daily'];
            if (dailyData == null || dailyData.isEmpty) {
              return Text('Error: No daily data available.');
            }
            Map<String, dynamic>? values = dailyData[0]['values'];
            if (values == null) {
              // Handle the case where values are null
              return Container();
            }
            String weatherStatus = '';
            String weatherSmallIcon = '';
            String weatherLargeIcon = '';

            switch(values['weatherCodeMin'].toString()){
              case '1000':
                weatherStatus = weatherCodeList[1].title;
                weatherSmallIcon = weatherCodeList[1].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[1].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '1100':
                weatherStatus = weatherCodeList[2].title;
                weatherSmallIcon = weatherCodeList[2].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[2].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '1101':
                weatherStatus = weatherCodeList[3].title;
                weatherSmallIcon = weatherCodeList[3].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[3].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '1102':
                weatherStatus = weatherCodeList[4].title;
                weatherSmallIcon = weatherCodeList[4].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[4].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '1001':
                log("# weather code111 ---- :${values['weatherCodeMin']} ");
                weatherStatus = weatherCodeList[5].title;
                weatherSmallIcon = weatherCodeList[5].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[5].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                log("# weather large Icon ---- :${weatherLargeIcon1} ");
                log("# weather status 222 ---- :${weatherStatusTitle} ");
                break;
              case '2000':
                weatherStatus = weatherCodeList[6].title;
                weatherSmallIcon = weatherCodeList[6].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[6].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '2100':
                weatherStatus = weatherCodeList[7].title;
                weatherSmallIcon = weatherCodeList[7].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[7].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '4000':
                weatherStatus = weatherCodeList[8].title;
                weatherSmallIcon = weatherCodeList[8].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[8].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '4001':
                weatherStatus = weatherCodeList[9].title;
                weatherSmallIcon = weatherCodeList[9].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[9].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '4200':
                weatherStatus = weatherCodeList[10].title;
                weatherSmallIcon = weatherCodeList[10].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[10].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '4201':
                weatherStatus = weatherCodeList[11].title;
                weatherSmallIcon = weatherCodeList[11].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[11].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '5000':
                weatherStatus = weatherCodeList[12].title;
                weatherSmallIcon = weatherCodeList[12].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[12].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '5001':
                weatherStatus = weatherCodeList[13].title;
                weatherSmallIcon = weatherCodeList[13].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[13].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '5100':
                weatherStatus = weatherCodeList[14].title;
                weatherSmallIcon = weatherCodeList[14].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[14].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '5101':
                weatherStatus = weatherCodeList[15].title;
                weatherSmallIcon = weatherCodeList[15].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[15].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '6000':
                weatherStatus = weatherCodeList[16].title;
                weatherSmallIcon = weatherCodeList[16].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[16].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '6001':
                weatherStatus = weatherCodeList[17].title;
                weatherSmallIcon = weatherCodeList[17].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[17].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '6200':
                weatherStatus = weatherCodeList[18].title;
                weatherSmallIcon = weatherCodeList[18].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[18].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '6201':
                weatherStatus = weatherCodeList[19].title;
                weatherSmallIcon = weatherCodeList[19].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[19].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '7000':
                weatherStatus = weatherCodeList[20].title;
                weatherSmallIcon = weatherCodeList[20].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[20].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '7101':
                weatherStatus = weatherCodeList[21].title;
                weatherSmallIcon = weatherCodeList[21].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[21].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '7102':
                weatherStatus = weatherCodeList[22].title;
                weatherSmallIcon = weatherCodeList[22].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[22].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              case '8000':
                weatherStatus = weatherCodeList[23].title;
                weatherSmallIcon = weatherCodeList[23].weatherSmallIcon;
                weatherLargeIcon = weatherCodeList[23].weatherLargeIcon;
                weatherStatusTitle = weatherStatus;
                weatherLargeIcon1 = weatherLargeIcon;
                weatherSmallIcon1 = weatherSmallIcon;
                break;
              default:
                weatherStatus = 'Unknown';
                weatherSmallIcon = '';
                weatherLargeIcon = '';
                break;
            }

            // Extracting relevant information
            String locationName = widget.data!;
            String countryName = "Country"; // Replace with actual country name
            log("# location name : $locationName");
            return Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 330,
                  height: 520,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xffFFFFFF),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x29000000),
                        offset: Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Location icon and country name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Icon(
                              Icons.location_on_outlined,
                              color: Color(0xff97A0A8),
                              size: 23,
                            ),
                          ),
                          Text(
                            '$locationName',
                            style: TextStyle(
                              color: Color(0xff97A0A8),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 15),
                            width: 140.w,
                            height: 130.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.r),
                                boxShadow:  null),
                            child: Image.asset(
                              weatherLargeIcon!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              '${dailyData[0]['values']["temperatureAvg"]}°',
                              style: TextStyle(
                                color: Color(0xff050505),
                                fontSize: 53.0,
                                // fontWeight: FontWeight.w700,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        weatherStatusTitle!,
                        style: TextStyle(
                          color: Color(0xff050505),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Text(
                        'feels like ${dailyData[0]['values']["temperatureApparentAvg"]}°',
                        style: TextStyle(
                          color: Color(0xff050505),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_upward,
                              color: Color(0xff050505),
                            size: 18,
                          ),
                          Text(
                            ' ${dailyData[0]['values']["temperatureApparentMax"]}° ',
                            style: TextStyle(
                              color: Color(0xff050505),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          widthBox(2.w),
                          Icon(
                            Icons.arrow_downward,
                            color: Color(0xff050505),
                            size: 18,
                          ),
                          Text(
                            '${dailyData[0]['values']["temperatureApparentMin"]}°',
                            style: TextStyle(
                              color: Color(0xff050505),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                      heightBox(40.h),
                      Text(
                        textAlign: TextAlign.center,
                        'Clear till tonight\nTemperatures are like yesterday',
                        style: TextStyle(
                          color: Color(0xff050505),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      heightBox(15.h),
                      Divider(color: Color(0xffEAEAEA),thickness: 3,),
                      heightBox(15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 28.r,
                            child: IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                              ),
                              iconSize: 45,
                              onPressed: ()async{
                                if(isPlaying){
                                  await player.pause();
                                }else{
                                  await player.resume();
                                }
                              },
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "Listen to today's weather\nsummary",
                                style: TextStyle(
                                  color: Color(0xff97A0A8),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 2,top: 0),
                                width: 217.w,
                                child: Slider(
                                  inactiveColor: Color(0xffEAEAEA),
                                    min: 0,
                                    max:duration.inSeconds.toDouble(),
                                    value: position.inSeconds.toDouble(),
                                    onChanged: (value) async{
                                      final position = Duration(seconds: value.toInt());
                                      await player.seek(position);
                                      await player.resume();
                                    },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

///

